#!/bin/bash

set -e

echo "🔽 Downloading files from Dropbox..."

# Download dalle_image_1.png
curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/dalle_image_1.png\"}" \
  --output dalle_image_1.png

# Download dalle_image_2.png
curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/dalle_image_2.png\"}" \
  --output dalle_image_2.png

# Download background_audio.mp3
curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/background_audio.mp3\"}" \
  --output background_audio.mp3

echo "🎬 Creating video with FFmpeg..."

# Generate video from the 2 images with fade transition
ffmpeg -y -loop 1 -t 5 -i dalle_image_1.png \
       -loop 1 -t 5 -i dalle_image_2.png \
       -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0,format=yuv420p[v]" \
       -map "[v]" -map 0:a? -shortest -i background_audio.mp3 \
       output_video.mp4

echo "📤 Uploading final video to Dropbox..."

curl -X POST https://content.dropboxapi.com/2/files/upload \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/output_video.mp4\", \"mode\": \"overwrite\"}" \
  --header "Content-Type: application/octet-stream" \
  --data-binary @output_video.mp4

echo "✅ All done."
