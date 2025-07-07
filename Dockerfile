# Use official Debian base image
FROM python:3.9-slim

# Install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg && apt-get clean

# Set working directory
WORKDIR /app

# Copy all required files into the container
COPY upload-test.py ./
COPY background_audio.mp3 ./
COPY dalle_image_1.png ./
COPY dalle_image_2.png ./

# Install Dropbox SDK
RUN pip install dropbox

# Set environment variable from Railway
ENV DROPBOX_TOKEN=${DROPBOX_TOKEN}

# Run the script
CMD ["python", "upload-test.py"]
