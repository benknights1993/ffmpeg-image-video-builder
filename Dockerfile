FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
  ffmpeg \
  curl \
  python3 \
  python3-pip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install required Python packages
RUN pip3 install requests

# Set environment variable
ENV ACCESS_TOKEN=${ACCESS_TOKEN}

# Copy script
COPY upload-test.py /app/upload-test.py

# Set working directory
WORKDIR /app

# Run the script
CMD ["python3", "upload-test.py"]
