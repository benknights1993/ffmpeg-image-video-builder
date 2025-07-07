import subprocess
import dropbox
import os

# Step 1: Trim the audio
subprocess.run([
    "ffmpeg", "-y",
    "-i", "background_audio.mp3",
    "-t", "20",
    "-acodec", "copy",
    "trimmed_audio.mp3"
], check=True)

# Step 2: Combine two images into a 20-second video with trimmed audio
subprocess.run([
    "ffmpeg", "-y",
    "-loop", "1", "-t", "10", "-i", "dalle_image_1.png",
    "-loop", "1", "-t", "10", "-i", "dalle_image_2.png",
    "-i", "trimmed_audio.mp3",
    "-filter_complex", "[0:v][1:v]concat=n=2:v=1:a=0,format=yuv420p[v]",
    "-map", "[v]",
    "-map", "2:a",
    "-shortest",
    "-r", "30",
    "-c:v", "libx264",
    "-c:a", "aac",
    "-b:a", "192k",
    "final_video.mp4"
], check=True)

# Step 3: Upload final video to Dropbox
DROPBOX_TOKEN = os.environ.get("DROPBOX_TOKEN")
if not DROPBOX_TOKEN:
    raise Exception("Missing DROPBOX_TOKEN environment variable.")

dbx = dropbox.Dropbox(DROPBOX_TOKEN)

with open("final_video.mp4", "rb") as f:
    dbx.files_upload(f.read(), "/FFmpegUploader/final_video.mp4", mode=dropbox.files.WriteMode("overwrite"))

print("✅ Upload complete.")
