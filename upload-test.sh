#!/bin/bash
set -e

echo "🔽 Downloading files from Dropbox..."

curl -X POST https://content.dropboxapi.com/2/files/download \
    --header "Authorization: Bearer $DROPBOX_TOKEN" \
    --header "Dropbox-API-Arg: {\"path\": \"/dalle_image_1.png\"}" \
    -o dalle_image_1.png

curl -X POST https://content.dropboxapi.com/2/files/download \
    --header "Authorization: Bearer $DROPBOX_TOKEN" \
    --header "Dropbox-API-Arg: {\"path\": \"/dalle_image_2.png\"}" \
    -o dalle_image_2.png

curl -X POST https://content.dropboxapi.com/2/files/download \
    --header "Authorization: Bearer $DROPBOX_TOKEN" \
    --header "Dropbox-API-Arg: {\"path\": \"/background_audio.mp3\"}" \
    -o background_audio.mp3

echo "✂️ Trimming background audio to 20 seconds..."
ffmpeg -y -i background_audio.mp3 -t 20 -acodec copy trimmed_audio.mp3

echo "🎬 Creating vertical video with effects..."

ffmpeg -y \
    -loop 1 -t 10 -i dalle_image_1.png \
    -loop 1 -t 10 -i dalle_image_2.png \
    -i trimmed_audio.mp3 \
    -filter_complex "\
        [0:v]scale=1080:1920,zoompan=z='zoom+0.001':d=250,format=yuv420p,fade=t=out:st=9:d=1:alpha=1[img1]; \
        [1:v]scale=1080:1920,zoompan=z='zoom+0.001':d=250,format=yuv420p,fade=t=in:st=0:d=1:alpha=1[img2]; \
        [img1][img2]xfade=transition=fade:duration=1:offset=9[video]" \
    -map "[video]" -map 2:a \
    -c:v libx264 -t 20 -pix_fmt yuv420p output_video.mp4

echo "📤 Uploading final video to Dropbox..."

curl -X POST https://content.dropboxapi.com/2/files/upload \
    --header "Authorization: Bearer $DROPBOX_TOKEN" \
    --header "Dropbox-API-Arg: {\"path\": \"/output_video.mp4\", \"mode\": \"overwrite\"}" \
    --header "Content-Type: application/octet-stream" \
    --data-binary @output_video.mp4

echo "✅ All done!"
