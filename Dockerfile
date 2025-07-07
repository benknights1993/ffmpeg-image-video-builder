FROM debian:bullseye-slim

# Install ffmpeg and curl
RUN apt-get update && \
    apt-get install -y ffmpeg curl && \
    apt-get clean

# Set working directory
WORKDIR /app

# Copy all files into the container
COPY . .

# Make the upload script executable
RUN chmod +x upload-test.sh

# Run the script
CMD ["bash", "upload-test.sh"]
