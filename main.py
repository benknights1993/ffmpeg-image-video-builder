import os
import requests
import subprocess

# URLs from n8n — these should eventually be passed dynamically
image_urls = [
    os.getenv("DALLE_IMAGE_1"),
    os.getenv("DALLE_IMAGE_2")
]

dummy_audio_url = "https://github.com/benknights1993/ffmpeg-image-video-builder/raw/main/dummy.mp3"

# Step 1: Download images and audio
os.makedirs("assets", exist_ok=True)

image_paths = []
for idx, url in enumerate(image_urls, start=1):
    image_path = f"assets/image{idx}.png"
    response = requests.get(url)
    with open(image_path, "wb") as f:
        f.write(response.content)
    image_paths.append(image_path)

audio_path = "assets/dummy.mp3"
audio_response = requests.get(dummy_audio_url)
with open(audio_path, "wb") as f:
    f.write(audio_response.content)

# Step 2: Use FFmpeg to make video from images and audio
output_path = "output.mp4"

ffmpeg_cmd = [
    "ffmpeg",
    "-loop", "1", "-t", "3", "-i", image_paths[0],
    "-loop", "1", "-t", "3", "-i", image_paths[1],
    "-i", audio_path,
    "-filter_complex",
    "[0:v]scale=1080:1920,setsar=1[v0];"
    "[1:v]scale=1080:1920,setsar=1[v1];"
    "[v0][v1]concat=n=2:v=1:a=0,format=yuv420p[video]",
    "-map", "[video]",
    "-map", "2:a",
    "-shortest",
    "-movflags", "+faststart",
    output_path
]

subprocess.run(ffmpeg_cmd, check=True)
print("Video created:", output_path)
