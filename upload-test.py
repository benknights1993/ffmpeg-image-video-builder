import os
import subprocess
import dropbox

DROPBOX_TOKEN = os.getenv("DROPBOX_TOKEN")

# Step 1: Trim audio to 20 seconds
subprocess.run([
    "ffmpeg", "-y",
    "-i", "background_audio.mp3",
    "-t", "20",
    "-acodec", "copy",
    "trimmed_audio.mp3"
], check=True)

# Step 2: Create video from DALL·E images and audio
subprocess.run([
    "ffmpeg", "-y",
    "-loop", "1", "-t", "10", "-i", "dalle_image_1.png",
    "-loop", "1", "-t", "10", "-i", "dalle_image_2.png",
    "-i", "trimmed_audio.mp3",
    "-filter_complex", "[0:v][1:v]concat=n=2:v=1:a=0,format=yuv420p[v]",
    "-map", "[v]",
    "-map", "2:a",
    "-shortest",
    "-vf", "scale=1080:-1",
    "-r", "30",
    "final_video.mp4"
], check=True)

# Step 3: Upload final video to Dropbox
dbx = dropbox.Dropbox(DROPBOX_TOKEN)
with open("final_video.mp4", "rb") as f:
    dbx.files_upload(f.read(), "/FFmpegUploader/final_video.mp4", mode=dropbox.files.WriteMode("overwrite"))
