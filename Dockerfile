FROM debian:bullseye-slim

# Install ffmpeg
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean

# Set working directory
WORKDIR /app

# Copy all files into the container
COPY . .

# Make the script executable
RUN chmod +x builder.sh

# Run the script
CMD ["./builder.sh"]
