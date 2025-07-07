import os
import dropbox
import subprocess

# Load Dropbox token from env
DROPBOX_TOKEN = os.environ.get("DROPBOX_TOKEN")

# Files
image1 = "dalle_image_1.png"
image2 = "dalle_image_2.png"
original_audio = "background_audio.mp3"
trimmed_audio = "trimmed_audio.mp3"
output_video = "output_video.mp4"

# Step 1: Trim audio to 20s
subprocess.run([
    "ffmpeg", "-y", "-i", original_audio,
    "-t", "20", "-acodec", "copy", trimmed_audio
])

# Step 2: Create vertical video with zoom and fade
filter_complex = (
    "[0:v]scale=1080:1920,zoompan=z='min(zoom+0.0015,1.5)':"
    "d=125:s=1080x1920:fps=25,setsar=1[v0];"
    "[1:v]scale=1080:1920,zoompan=z='min(zoom+0.0015,1.5)':"
    "d=125:s=1080x1920:fps=25,setsar=1[v1];"
    "[v0][v1]xfade=transition=fade:duration=1:offset=9,format=yuv420p[v]"
)

subprocess.run([
    "ffmpeg", "-y",
    "-loop", "1", "-t", "10", "-i", image1,
    "-loop", "1", "-t", "10", "-i", image2,
    "-i", trimmed_audio,
    "-filter_complex", filter_complex,
    "-map", "[v]", "-map", "2:a",
    "-shortest", output_video
])

# Step 3: Upload to Dropbox
dbx = dropbox.Dropbox(DROPBOX_TOKEN)
with open(output_video, "rb") as f:
    dbx.files_upload(f.read(), f"/FFmpegUploader/{output_video}", mode=dropbox.files.WriteMode.overwrite)

print("✅ Upload complete!")
