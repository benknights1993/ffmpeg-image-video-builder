# Use official Python slim image
FROM python:3.9-slim

# Install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg && apt-get clean

# Set working directory
WORKDIR /app

# Copy everything needed into container
COPY upload-test.py .
COPY background_audio.mp3 .
COPY dalle_image_1.png .
COPY dalle_image_2.png .

# Install Dropbox SDK
RUN pip install dropbox

# Set the Dropbox token from Railway's environment
ENV DROPBOX_TOKEN=${DROPBOX_TOKEN}

# Start script
CMD ["python", "upload-test.py"]
