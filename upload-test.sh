#!/bin/bash

echo "🔽 Downloading files from Dropbox..."

# Download dalle_image_1.png
curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $DROPBOX_ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/dalle_image_1.png\"}" \
  --output dalle_image_1.png

# Download dalle_image_2.png
curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $DROPBOX_ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/dalle_image_2.png\"}" \
  --output dalle_image_2.png

# Download background_audio.mp3
curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer $DROPBOX_ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/background_audio.mp3\"}" \
  --output background_audio.mp3

echo "✂️ Trimming background audio to 20 seconds..."
ffmpeg -y -t 20 -i background_audio.mp3 -acodec copy trimmed_audio.mp3

echo "🎬 Creating vertical video with pan/zoom + fade transitions..."
ffmpeg -y \
  -loop 1 -t 10 -i dalle_image_1.png \
  -loop 1 -t 10 -i dalle_image_2.png \
  -i trimmed_audio.mp3 \
  -filter_complex "\
    [0:v]scale=1080:1920,zoompan=z='zoom+0.0005':d=250:s=1080x1920,fade=t=out:st=9:d=1[v0]; \
    [1:v]scale=1080:1920,zoompan=z='zoom+0.0005':d=250:s=1080x1920,fade=t=in:st=0:d=1[v1]; \
    [v0][v1]concat=n=2:v=1:a=0[outv]" \
  -map "[outv]" -map 2:a \
  -shortest \
  -preset veryfast \
  output_video.mp4

echo "✅ Video created: output_video.mp4"

echo "📤 Uploading video to Dropbox..."
curl -X POST https://content.dropboxapi.com/2/files/upload \
  --header "Authorization: Bearer $DROPBOX_ACCESS_TOKEN" \
  --header "Content-Type: application/octet-stream" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/output_video.mp4\", \"mode\": \"overwrite\"}" \
  --data-binary @output_video.mp4

echo "✅ Upload complete!"
