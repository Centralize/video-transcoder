#!/bin/bash

# Input video formats
input_formats=("mp4" "mkv" "avi") # Add more formats if needed

# Output video format
output_format="mp4" # Change to desired output format

# Number of concurrent video streams to handle
num_streams=8

# Array to store incoming streams
incoming_streams=()

# Loop to transcode videos in real-time
while true; do
  # Check if incoming streams array is not full
  if [ ${#incoming_streams[@]} -lt $num_streams ]; then
    for i in "${input_formats[@]}"; do
      input_files=($(ls *.$i 2>/dev/null)) # Get all files with the input format
      for file in "${input_files[@]}"; do
        if [[ ! " ${incoming_streams[@]} " =~ " ${file} " ]]; then
          # Add incoming stream to array
          incoming_streams+=("$file")
          echo "Incoming stream: $file"
        fi
      done
    done
  fi

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

