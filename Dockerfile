FROM python:3.10-slim

# Install ffmpeg
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean

# Set working directory
WORKDIR /app

# Copy all necessary files
COPY upload-test.sh upload-test.sh
COPY image1.png image1.png
COPY image2.png image2.png
COPY background_audio.mp3 background_audio.mp3

# Install Dropbox SDK for Python
RUN pip install dropbox

# Make the shell script executable
RUN chmod +x upload-test.sh

# Run the script
CMD ["bash", "upload-test.sh"]
