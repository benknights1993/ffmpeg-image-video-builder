# Use official Debian base image
FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
  ffmpeg \
  curl \
  python3 \
  python3-pip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Dropbox SDK
RUN pip3 install dropbox

# Set environment variable from Railway
ENV DROPBOX_TOKEN=${DROPBOX_TOKEN}

# Copy your script into the container
COPY upload-test.py /app/upload-test.py

# Set working directory
WORKDIR /app

# Run the script when container starts
CMD ["python3", "upload-test.py"]
