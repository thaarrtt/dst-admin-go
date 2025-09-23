#!/bin/bash
# Test script to verify docker-entrypoint.sh works correctly

echo "Testing docker-entrypoint.sh script..."

# Check if the script exists
if [ ! -f "./docker-entrypoint.sh" ]; then
    echo "ERROR: docker-entrypoint.sh not found!"
    exit 1
fi

# Check if the script is executable
if [ ! -x "./docker-entrypoint.sh" ]; then
    echo "ERROR: docker-entrypoint.sh is not executable!"
    exit 1
fi

# Check the shebang line
first_line=$(head -n 1 ./docker-entrypoint.sh)
if [ "$first_line" != "#!/bin/bash" ]; then
    echo "WARNING: First line is not #!/bin/bash, it is: $first_line"
fi

echo "Script check passed!"
echo "To test in Docker, run: docker run -it --rm -v $(pwd):/app ubuntu:20.04 /app/docker-entrypoint.sh"