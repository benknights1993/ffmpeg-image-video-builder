import os
import dropbox
import subprocess

DROPBOX_TOKEN = os.environ.get("DROPBOX_TOKEN")

if not DROPBOX_TOKEN:
    raise Exception("❌ DROPBOX_TOKEN not set!")

# Filenames (make sure these match what's in Dropbox!)
image_files = ["dalle_image_1.png", "dalle_image_2.png"]
audio_file = "background_audio.mp3"
trimmed_audio = "trimmed_audio.mp3"
output_video = "output_video.mp4"

# 1. Trim audio to 20 seconds
subprocess.run([
    "ffmpeg", "-y", "-i", audio_file,
    "-t", "20", "-acodec", "copy", trimmed_audio
], check=True)

# 2. Create vertical video from images with fade + zoom
filters = []
for i, image in enumerate(image_files):
    start = i * 10
    end = start + 10
    fade_out = f"fade=t=out:st={end - 1}:d=1"

    filters.append(
        f"[{i}:v]scale=1080:1920,zoompan=z='1.0+0.1*in':d=250:s=1080x1920,"
        f"{fade_out},setpts=PTS-STARTPTS[v{i}]"
    )

filter_complex = ";".join(filters) + f";[v0][v1]concat=n=2:v=1:a=0[outv]"

ffmpeg_cmd = [
    "ffmpeg", "-y",
    "-loop", "1", "-t", "10", "-i", image_files[0],
    "-loop", "1", "-t", "10", "-i", image_files[1],
    "-i", trimmed_audio,
    "-filter_complex", filter_complex,
    "-map", "[outv]", "-map", "2:a",
    "-shortest", "-pix_fmt", "yuv420p", output_video
]

subprocess.run(ffmpeg_cmd, check=True)

# 3. Upload to Dropbox
dbx = dropbox.Dropbox(DROPBOX_TOKEN)
with open(output_video, "rb") as f:
    dbx.files_upload(f.read(), f"/{output_video}", mode=dropbox.files.WriteMode.overwrite)

print("✅ Upload complete!")
