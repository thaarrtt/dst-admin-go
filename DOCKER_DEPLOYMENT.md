# Docker Deployment Guide

This guide provides instructions for properly deploying the DST Admin Go application using Docker.

## Quick Start

### Using the Simple Run Script (Recommended)

```bash
# Give the script execution permissions
chmod +x run-dst-admin.sh

# Run with default settings
./run-dst-admin.sh

# Run with custom settings
./run-dst-admin.sh -n my-dst-server -p 8080
```

### Manual Docker Run

```bash
# Build the Docker image
./docker_build.sh latest

# Run the container with proper settings
docker run -d --name dst-admin-go \
  -p 8082:8082 \
  -p 10998:10998/udp \
  -p 10999:10999/udp \
  --ulimit nofile=65536:65536 \
  hujinbo23/dst-admin-go:latest
```

## Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: "3"

services:
  dst-admin-go:
    image: hujinbo23/dst-admin-go:latest
    container_name: dst-admin-go
    ports:
      - "8082:8082"
      - "10998:10998/udp"
      - "10999:10999/udp"
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
    volumes:
      - ./dstsave:/root/.klei/DoNotStarveTogether
      - ./dstsave/back:/app/backup
      - ./steamcmd:/app/steamcmd
      - ./dst-dedicated-server:/app/dst-dedicated-server
      - ./dstsave/dst-db:/app/dst-db
      - ./dstsave/password.txt:/app/password.txt
      - ./dstsave/first:/app/first
    restart: unless-stopped
```

Then run:
```bash
docker-compose up -d
```

## Port Configuration

The following ports need to be exposed:

- `8082/tcp` - Web panel port
- `10998/udp` - Caves world port
- `10999/udp` - Forest world port
- `10888/udp` - Master server communication port

## Performance Optimization

Docker's default nofile limit can cause GNU Screen to run slowly, which affects the launch and manipulation of the Don't Starve service. This is fixed by setting:

```bash
--ulimit nofile=65536:65536
```

Or in docker-compose:
```yaml
ulimits:
  nofile:
    soft: 65536
    hard: 65536
```

## Volume Mounting

For persistent data, mount the following directories/files:

- `/root/.klei/DoNotStarveTogether` - Game save files
- `/app/backup` - Backup files
- `/app/steamcmd` - SteamCMD installation
- `/app/dst-dedicated-server` - DST dedicated server installation
- `/app/dst-db` - Database file (sqlite)
- `/app/password.txt` - User credentials
- `/app/first` - First-time login indicator

## Environment Variables

The application can be configured using the following environment variables in `config.yml`:

- `port` - Web panel port (default: 8082)
- `database` - Database file path (default: dst-db)
- `steamcmd` - SteamCMD path (default: /app/steamcmd)

## Troubleshooting

### Container starts but web panel doesn't respond

Ensure all required ports are exposed:
```bash
docker run -p 8082:8082 -p 10998:10998/udp -p 10999:10999/udp ...
```

### Slow server startup

Ensure the nofile ulimit is set correctly:
```bash
docker run --ulimit nofile=65536:65536 ...
```

### Configuration persistence after container restart

Use volume mounting to persist data:
```bash
docker run -v ./dstsave:/root/.klei/DoNotStarveTogether ...
```