#!/bin/bash

# Inputs
IMAGE1="dalle_image_1.png"
IMAGE2="dalle_image_2.png"
AUDIO="58155788_calm-background-documentary-music-kit_by_tuureckij_preview.mp3"
OUTPUT="output_video.mp4"

# Step 1: Convert each image into a 10-second video
ffmpeg -y -loop 1 -t 10 -i "$IMAGE1" -vf "scale=1280:720,format=yuv420p" -c:v libx264 image1.mp4
ffmpeg -y -loop 1 -t 10 -i "$IMAGE2" -vf "scale=1280:720,format=yuv420p" -c:v libx264 image2.mp4

# Step 2: Crossfade between the two clips
ffmpeg -y -i image1.mp4 -i image2.mp4 -filter_complex \
"[0:v]format=yuv420p,fade=t=out:st=9:d=1[v0]; \
 [1:v]format=yuv420p,fade=t=in:st=0:d=1[v1]; \
 [v0][v1]concat=n=2:v=1:a=0[outv]" \
-map "[outv]" merged_video.mp4

# Step 3: Trim audio to match and add it
ffmpeg -y -i merged_video.mp4 -i "$AUDIO" -shortest -c:v copy -c:a aac "$OUTPUT"

echo "✅ Done! Output saved to $OUTPUT"
