#!/bin/bash
set -e

# Dropbox access token from Railway variable
ACCESS_TOKEN=$ACCESS_TOKEN

# Download files from Dropbox
echo "🔽 Downloading files from Dropbox..."
curl -s -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/dalle_image_1.png\"}" \
  --output dalle_image_1.png

curl -s -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/dalle_image_2.png\"}" \
  --output dalle_image_2.png

curl -s -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/background_audio.mp3\"}" \
  --output background_audio.mp3

echo "🎬 Creating video with FFmpeg..."
ffmpeg -y \
  -loop 1 -t 5 -i dalle_image_1.png \
  -loop 1 -t 5 -i dalle_image_2.png \
  -i background_audio.mp3 \
  -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0,format=yuv420p[v]" \
  -map "[v]" -map 2:a \
  -shortest output_video.mp4

echo "📤 Uploading final video to Dropbox..."
curl -X POST https://content.dropboxapi.com/2/files/upload \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/output_video.mp4\", \"mode\": \"overwrite\"}" \
  --header "Content-Type: application/octet-stream" \
  --data-binary @output_video.mp4

echo "✅ All done!"
