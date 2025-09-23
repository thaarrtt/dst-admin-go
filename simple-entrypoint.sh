#!/bin/bash
set -e

echo "Starting DST Admin Go..."

# Simple test to see if we can run the app directly
if [ -f "/app/dst-admin-go" ]; then
    echo "Found dst-admin-go binary, starting it..."
    cd /app
    exec ./dst-admin-go
else
    echo "ERROR: dst-admin-go binary not found!"
    echo "Contents of /app:"
    ls -la /app/
    exit 1
fi