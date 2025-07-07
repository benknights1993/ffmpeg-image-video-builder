import os
import subprocess
import dropbox

# Step 1: Trim audio
subprocess.run([
    "ffmpeg", "-y", "-i", "background_audio.mp3", "-t", "20",
    "-acodec", "copy", "trimmed_audio.mp3"
], check=True)

# Step 2: Create video from DALL·E images
subprocess.run([
    "ffmpeg", "-y",
    "-loop", "1", "-t", "10", "-i", "dalle_image_1.png",
    "-loop", "1", "-t", "10", "-i", "dalle_image_2.png",
    "-filter_complex",
    "[0:v][1:v]concat=n=2:v=1:a=0,format=yuv420p[v]",
    "-map", "[v]", "-map", "1:a?",  # audio optional
    "-shortest", "-vf", "scale=1080:-1", "-r", "30",
    "-i", "trimmed_audio.mp3",
    "final_video.mp4"
], check=True)

# Step 3: Upload to Dropbox
DROPBOX_TOKEN = os.environ.get("DROPBOX_TOKEN")
if not DROPBOX_TOKEN:
    raise Exception("Missing Dropbox token!")

dbx = dropbox.Dropbox(DROPBOX_TOKEN)
with open("final_video.mp4", "rb") as f:
    dbx.files_upload(f.read(), "/final_video.mp4", mode=dropbox.files.WriteMode("overwrite"))

print("✅ Upload complete!")
