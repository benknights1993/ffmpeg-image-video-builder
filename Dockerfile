FROM debian:bullseye-slim

# Install ffmpeg and python3
RUN apt-get update && \
    apt-get install -y ffmpeg python3 python3-pip && \
    apt-get clean

# Set working directory
WORKDIR /app

# Copy all files into the container
COPY . .

# Install Dropbox SDK
RUN pip3 install dropbox

# Run the script
CMD ["python3", "upload-test.py"]
