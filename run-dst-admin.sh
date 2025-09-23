#!/bin/bash

# Simple script to run the dst-admin-go container with proper settings
# This addresses the issues mentioned in documentation reference #80

# Default values
CONTAINER_NAME="dst-admin-go"
IMAGE_NAME="hujinbo23/dst-admin-go:latest"
PORT_WEB=8082
PORT_CAVES=10998
PORT_FOREST=10999

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -n|--name)
      CONTAINER_NAME="$2"
      shift 2
      ;;
    -i|--image)
      IMAGE_NAME="$2"
      shift 2
      ;;
    -p|--port)
      PORT_WEB="$2"
      shift 2
      ;;
    --caves-port)
      PORT_CAVES="$2"
      shift 2
      ;;
    --forest-port)
      PORT_FOREST="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  -n, --name NAME          Container name (default: dst-admin-go)"
      echo "  -i, --image IMAGE        Image name (default: hujinbo23/dst-admin-go:latest)"
      echo "  -p, --port PORT          Web panel port (default: 8082)"
      echo "  --caves-port PORT        Caves world port (default: 10998)"
      echo "  --forest-port PORT       Forest world port (default: 10999)"
      echo "  -h, --help               Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

echo "Running Don't Starve Together Admin Panel..."
echo "Container name: $CONTAINER_NAME"
echo "Image: $IMAGE_NAME"
echo "Ports: $PORT_WEB (web), $PORT_CAVES (caves), $PORT_FOREST (forest)"

# Run the container with proper settings
docker run -d \
  --name "$CONTAINER_NAME" \
  -p "$PORT_WEB":8082 \
  -p "$PORT_CAVES":10998/udp \
  -p "$PORT_FOREST":10999/udp \
  --ulimit nofile=65536:65536 \
  "$IMAGE_NAME"

if [ $? -eq 0 ]; then
  echo "Container started successfully!"
  echo "Access the web panel at: http://localhost:$PORT_WEB"
  echo "To view logs: docker logs $CONTAINER_NAME"
  echo "To stop: docker stop $CONTAINER_NAME"
else
  echo "Failed to start container!"
  exit 1
fi