#!/usr/bin/env bash

IMAGE_NAME="spring-boot-playground:local"
CONTAINER_NAME="spring-boot-playground"

set -e

echo "🛑 Stopping and removing old container..."
docker stop $CONTAINER_NAME || true
sleep 1
docker rm $CONTAINER_NAME || true
sleep 1

echo "🗑 Removing old image..."
docker rmi -f $IMAGE_NAME || true
sleep 1

echo "🔨 Rebuilding image..."
docker build -t $IMAGE_NAME .

echo "🚀 Starting container..."
docker-compose -f docker-compose.local.yml up

echo "✅ Done!"
