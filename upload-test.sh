#!/bin/bash

echo "🔽 Downloading files from Dropbox..."

# Download dalle_image_1.png
curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/dalle_image_1.png\"}" \
  --output dalle_image_1.png

# Download dalle_image_2.png
curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/dalle_image_2.png\"}" \
  --output dalle_image_2.png

# Download background_audio.mp3
curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/background_audio.mp3\"}" \
  --output background_audio.mp3

echo "🎬 Creating video with FFmpeg..."

# Combine images and audio into a 10-second video
ffmpeg -y \
  -loop 1 -t 5 -i dalle_image_1.png \
  -loop 1 -t 5 -i dalle_image_2.png \
  -i background_audio.mp3 \
  -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0,format=yuv420p[v]" \
  -map "[v]" -map 2:a \
  -shortest output_video.mp4

# Check if the output file was created
if [ -f "output_video.mp4" ]; then
  echo "📤 Uploading final video to Dropbox..."

  curl -X POST https://content.dropboxapi.com/2/files/upload \
    --header "Authorization: Bearer $ACCESS_TOKEN" \
    --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/output_video.mp4\", \"mode\": \"overwrite\"}" \
    --header "Content-Type: application/octet-stream" \
    --data-binary @"output_video.mp4"

  echo "✅ All done!"
else
  echo "❌ Failed to create output_video.mp4. Check FFmpeg logs for details."
fi
