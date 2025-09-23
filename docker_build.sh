#!/bin/bash

# 获取命令行参数
TAG=${1:-latest}

echo "Building Docker image with tag: hujinbo23/dst-admin-go:$TAG"

# 构建镜像
docker build -t hujinbo23/dst-admin-go:$TAG .

if [ $? -eq 0 ]; then
    echo "Docker image built successfully!"
    echo "To run the container:"
    echo "docker run -d --name dst-admin-go -p 8082:8082 -p 10998:10998/udp -p 10999:10999/udp --ulimit nofile=65536:65536 hujinbo23/dst-admin-go:$TAG"
    
    # 推送镜像到Docker Hub (only if TAG is not "local")
    if [ "$TAG" != "local" ]; then
        echo "Pushing image to Docker Hub..."
        docker push hujinbo23/dst-admin-go:$TAG
        if [ $? -eq 0 ]; then
            echo "Image pushed successfully!"
        else
            echo "Failed to push image to Docker Hub"
            exit 1
        fi
    else
        echo "Local build completed. Skipping Docker Hub push."
    fi
else
    echo "Docker build failed!"
    exit 1
fi