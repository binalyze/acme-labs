# Binalyze AIR Lab Environment

A Docker Compose environment for deploying and testing Binalyze AIR across multiple Linux distributions simultaneously. This lab environment creates 200 containers running different Linux distributions (Ubuntu, Debian, and Fedora) to test AIR deployment and functionality.

## Overview

This project provides a containerized lab environment for:
- **Testing Binalyze AIR deployment** across different Linux distributions
- **Load testing** AIR installation processes
- **Development and QA** for AIR deployment scripts
- **Multi-platform compatibility testing**

The environment consists of:
- **50 Ubuntu containers** (air-ubuntu-1 to air-ubuntu-50)
- **50 Debian containers** (air-debian-51 to air-debian-100)
- **50 CentOS containers** (air-centos-101 to air-centos-150)
- **50 Fedora containers** (air-fedora-151 to air-fedora-200)

Each container automatically deploys Binalyze AIR using the deployment script and configuration from your `.env.local` file.

## Prerequisites

- Docker and Docker Compose installed
- Sufficient system resources (200 containers require significant CPU/memory)
- Valid Binalyze AIR deployment URL

## Quick Start

1. **Clone this repository**
   ```bash
   git clone <repository-url>
   cd air-lab-environment
   ```

2. **Create your environment configuration**
   ```bash
   cp .env.local.example .env.local
   ```
   Edit `.env.local` with your Binalyze AIR deployment URL (see configuration section below).

3. **Start all containers**
   ```bash
   docker-compose up -d
   ```

4. **Monitor deployment progress**
   ```bash
   docker-compose logs -f
   ```

## Configuration

### Environment File (.env.local)

Create a `.env.local` file with the following structure:

```yaml
AIR:
  RESPONDER_PACKAGE_URL: "https://my-air.binalyze.com/api/endpoints/download/100/deploy/linux?deployment-token=1234567890123456"
```

> **Important:** Replace the URL with your actual Binalyze AIR deployment URL. This URL should point to the deployment package you can extract from the cURL command.

## Usage

### Starting the Environment

```bash
# Start all 200 containers
docker-compose up -d

# Start specific containers (e.g., only Ubuntu containers 1-10)
docker-compose up -d air-ubuntu-1 air-ubuntu-2 air-ubuntu-3 air-ubuntu-4 air-ubuntu-5 air-ubuntu-6 air-ubuntu-7 air-ubuntu-8 air-ubuntu-9 air-ubuntu-10

# Start containers by distribution type
docker-compose up -d $(docker-compose config --services | grep ubuntu)
docker-compose up -d $(docker-compose config --services | grep debian)
docker-compose up -d $(docker-compose config --services | grep centos)
docker-compose up -d $(docker-compose config --services | grep fedora)
```

### Monitoring and Debugging

```bash
# View logs from all containers
docker-compose logs -f

# View logs from specific container
docker-compose logs -f air-ubuntu-1

# Check container status
docker-compose ps

# Execute commands in a container
docker-compose exec air-ubuntu-1 /bin/bash

# View AIR installation directory
docker-compose exec air-ubuntu-1 ls -la /opt/binalyze/air
```

### Scaling Operations

```bash
# Stop all containers
docker-compose down

# Stop and remove all containers and volumes
docker-compose down -v

# Restart specific containers
docker-compose restart air-ubuntu-1 air-debian-51 air-centos-101 air-fedora-151

# View resource usage
docker stats
```

## Container Details

### Container Configuration
- **Privileged mode**: Required for AIR installation
- **Auto-restart**: Containers restart unless manually stopped
- **Volume mounts**:
  - `./deploy.sh:/app/deploy.sh:ro` - Deployment script (read-only)
  - `./.env.local:/app/.env.local:ro` - Configuration file (read-only)

### Supported Distributions
- **Ubuntu Latest** (50 containers)
- **Debian Latest** (50 containers)
- **CentOS Latest** (50 containers)
- **Fedora Latest** (50 containers)

Each container runs the deployment script automatically on startup and keeps running to maintain the AIR installation.

## Deployment Script

The `deploy.sh` script performs the following operations:
1. Detects the Linux distribution and package manager
2. Updates package repositories
3. Installs required dependencies (curl, sudo)
4. Reads the deployment URL from `.env.local`
5. Downloads and executes the AIR installer
6. Verifies the installation
7. Keeps the container running

## System Requirements

### Minimum Requirements
- **CPU**: 8+ cores recommended
- **RAM**: 16+ GB recommended  
- **Storage**: 50+ GB available space
- **Network**: Stable internet connection for downloads

### Resource Usage
Each container requires approximately:
- **CPU**: 0.1-0.5 cores during deployment
- **RAM**: 128-512 MB per container
- **Storage**: 200-500 MB per container

## Troubleshooting

### Common Issues

**Container startup failures:**
```bash
# Check container logs
docker-compose logs air-ubuntu-1

# Verify .env.local exists and is properly formatted
cat .env.local
```

**Deployment URL errors:**
- Ensure the URL in `.env.local` is accessible
- Check network connectivity from containers
- Verify the deployment script URL returns a valid shell script

**Resource constraints:**
```bash
# Monitor system resources
docker stats

# Start fewer containers if system is constrained
docker-compose up -d air-ubuntu-1 air-debian-51 air-centos-101 air-fedora-151
```

**AIR installation failures:**
```bash
# Check AIR installation directory
docker-compose exec air-ubuntu-1 ls -la /opt/binalyze/

# Review deployment logs
docker-compose logs air-ubuntu-1 | grep -i error
```

## Development

### Modifying the Environment

1. **Update deployment script**: Edit `deploy.sh`
2. **Change container configuration**: Modify `docker_compose.yml`
3. **Add new distributions**: Add new service definitions in `docker_compose.yml`

### Testing Changes

```bash
# Rebuild and restart containers after changes
docker-compose down
docker-compose up -d --build
```

## Security Considerations

- Containers run in privileged mode (required for AIR installation)
- Deployment scripts are mounted read-only
- Environment configuration is mounted read-only
- Consider network isolation for production testing

## Support

For issues related to:
- **This lab environment**: Check container logs and system resources
- **Binalyze AIR**: Consult Binalyze AIR documentation
- **Docker/Docker Compose**: Refer to Docker documentation