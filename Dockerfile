# Use an image with Python and curl preinstalled
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy all files
COPY . .

# Make the script executable
RUN chmod +x upload-test.sh

# Run the upload script
CMD ["bash", "upload-test.sh"]
