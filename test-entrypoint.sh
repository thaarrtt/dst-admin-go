#!/bin/bash
echo "This is a simple test entrypoint"
echo "Current directory: $(pwd)"
echo "Files in current directory: $(ls -la)"
echo "Files in root: $(ls -la /)"
exec /app/dst-admin-go