# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Install required packages (ffmpeg and netcat)
RUN apt-get update && apt-get install -y ffmpeg netcat

# Copy the transcoding script to the container
COPY transcode.sh /transcode.sh

# Set the default UDP port to 8043
EXPOSE 8043/udp

# Start the transcoding script on container startup
CMD ["bash", "/transcode.sh", "8043", "udp"]
