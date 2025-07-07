# Use official Debian base image
FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
  ffmpeg \
  curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set environment variable from Railway
ENV ACCESS_TOKEN=${ACCESS_TOKEN}

# Copy your upload + ffmpeg script into the container
COPY upload-test.sh /app/upload-test.sh

# Set working directory
WORKDIR /app

# Make script executable
RUN chmod +x upload-test.sh

# Run the script when container starts
CMD ["bash", "upload-test.sh"]
