#!/bin/bash

echo "🔽 Downloading files from Dropbox..."

curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/dalle_image_1.png\"}" \
  --output dalle_image_1.png

curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/dalle_image_2.png\"}" \
  --output dalle_image_2.png

curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/background_audio.mp3\"}" \
  --output background_audio.mp3

echo "🎬 Creating video with FFmpeg..."

ffmpeg -y \
  -loop 1 -t 5 -i dalle_image_1.png \
  -loop 1 -t 5 -i dalle_image_2.png \
  -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0[outv]" \
  -map "[outv]" -i background_audio.mp3 \
  -shortest output_video.mp4

echo "📤 Uploading final video to Dropbox..."

curl -X POST https://content.dropboxapi.com/2/files/upload \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/output_video.mp4\", \"mode\": \"overwrite\"}" \
  --header "Content-Type: application/octet-stream" \
  --data-binary @output_video.mp4

echo "✅ All done!"
