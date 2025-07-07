#!/bin/bash
set -e

ACCESS_TOKEN=$ACCESS_TOKEN

# Download from Dropbox
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

echo "🎬 Creating animated video with FFmpeg..."

# Calculate duration from audio (in seconds)
AUDIO_DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 background_audio.mp3)
AUDIO_DURATION_INT=${AUDIO_DURATION%.*}
IMAGE_DURATION=$(( AUDIO_DURATION_INT / 2 ))  # Each image shows for half the audio

ffmpeg -y \
  -loop 1 -t $IMAGE_DURATION -i dalle_image_1.png \
  -loop 1 -t $IMAGE_DURATION -i dalle_image_2.png \
  -i background_audio.mp3 \
  -filter_complex "\
[0:v]zoompan=z='zoom+0.001':d=25*${IMAGE_DURATION}:s=1280x720,fade=t=out:st=$(($IMAGE_DURATION - 1)):d=1[vp0];\
[1:v]zoompan=z='zoom+0.001':d=25*${IMAGE_DURATION}:s=1280x720,fade=t=in:st=0:d=1[vp1];\
[vp0][vp1]concat=n=2:v=1:a=0[outv]" \
  -map "[outv]" -map 2:a -shortest \
  -pix_fmt yuv420p output_video.mp4

echo "📤 Uploading final video to Dropbox..."
curl -X POST https://content.dropboxapi.com/2/files/upload \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Dropbox-API-Arg: {\"path\": \"/FFmpegUploader/output_video.mp4\", \"mode\": \"overwrite\"}" \
  --header "Content-Type: application/octet-stream" \
  --data-binary @output_video.mp4

echo "✅ All done!"
