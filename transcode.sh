#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if ffmpeg and nc are installed
if ! command_exists "ffmpeg" || ! command_exists "nc"; then
  echo "Error: Required components (ffmpeg and nc) are not installed."
  echo "Please install them before running this script."
  exit 1
fi

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <port>"
  exit 1
fi

port="$1" # Port number for UDP server

# Input video formats
input_formats=("mp4" "mkv" "avi") # Add more formats if needed

# Output video format
output_format="mp4" # Change to desired output format

# Number of concurrent video streams to handle
num_streams=8

# Array to store incoming streams
incoming_streams=()

# Start UDP server to listen for incoming streams
nc -ul -p "$port" | while true; do
  # Check if incoming streams array is not full
  if [ ${#incoming_streams[@]} -lt $num_streams ]; then
    read -r file
    if [[ ! " ${incoming_streams[@]} " =~ " ${file} " ]]; then
      # Add incoming stream to array
      incoming_streams+=("$file")
      echo "Incoming stream: $file"
    fi
  fi
done &

# Loop to transcode videos in real-time
while true; do
  # Process incoming streams
  for stream in "${incoming_streams[@]}"; do
    # Transcode video in the background
    ffmpeg -i "$stream" -c:v libx264 -preset fast -c:a aac -b:a 128k "${stream%%.*}.$output_format" &
    echo "Transcoding $stream to ${stream%%.*}.$output_format"
    rm "$stream" # Remove the original input file
    # Remove processed stream from array
    incoming_streams=("${incoming_streams[@]/$stream}")
  done

  sleep 5 # Adjust sleep time as needed
done

