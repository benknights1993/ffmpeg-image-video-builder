# Force rebuild
FROM python:3.10-slim

FROM python:3.10-slim

# Install system dependencies and ffmpeg
RUN apt-get update && \
    apt-get install -y ffmpeg curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy all necessary files into the container
COPY upload-test.sh upload-test.sh
COPY image1.png image1.png
COPY image2.png image2.png
COPY background_audio.mp3 background_audio.mp3

# Make the shell script executable
RUN chmod +x upload-test.sh

# Run the script
CMD ["bash", "upload-test.sh"]
