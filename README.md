# Realtime Video Transcoder with que system

This is a complete rewrite of an earlier project.

To make this script run effeciently, an 8 channel hardware mp4 encoder is needed.

Usage: ./transcode.sh

### Version: 2.0

## Run as a Docker container.

### Build container.

<pre>docker build -t ubuntu-transcoder .</pre>

### Run container.

<pre>docker run -d -p 8043:8043/udp ubuntu-transcoder</pre>
