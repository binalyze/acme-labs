# Binalyze ACME Labs

A comprehensive Docker Compose environment for creating a multi-container lab setup simulating workstations, servers, and business applications to test Binalyze AIR.

## Overview

This project provides a containerized lab environment with:
- **10 Ubuntu Workstation containers** with Binalyze AIR agents for security testing and development
- **Web servers** for hosting applications and services
- **Multiple database systems** for data storage and testing
- **Message queuing** for distributed applications
- **Enterprise applications** for real-world scenarios

Perfect for PoVs, demos, research, development, testing, learning, and proof of concepts.

## Services

### Workstations (10 containers)
- **workstation-1** to **workstation-10** - Ubuntu-based development environments with Binalyze AIR agents

### Web Servers
- **nginx** - Web server (ports 8080, 8443)
- **httpd** - Apache HTTP server (port 8081)
- **tomcat** - Java application server (port 8082)

### Databases
- **postgres** - PostgreSQL database (port 5432)
- **mongo** - MongoDB NoSQL database (port 27017)
- **redis** - In-memory data store (port 6379)
- **cassandra** - Distributed NoSQL database (ports 9042, 9160)

### Message Queue
- **rabbitmq** - Message broker with web UI (ports 5672, 15672)

### Applications
- **nextcloud** - File sharing platform (port 8088)
- **ghost** - Blogging platform (port 8089)

## Quick Start

1. **Create environment configuration**
   ```bash
   # Create .env.local file with your Binalyze AIR deployment URL
   cat > .env.local << EOF
   AIR:
           RESPONDER_PACKAGE_URL: https://your-air-server.com/api/endpoints/download/deploy/linux?deployment-token=your-token
   EOF
   ```

2. **Start all services**
   ```bash
   docker-compose up -d
   ```

3. **Check status**
   ```bash
   docker-compose ps
   ```

4. **View logs**
   ```bash
   docker-compose logs -f
   ```

## Access Services

**Web Services:**
- Nginx: http://localhost:8080
- Apache: http://localhost:8081
- Tomcat: http://localhost:8082

**Databases:**
- PostgreSQL: localhost:5432
- MongoDB: localhost:27017
- Redis: localhost:6379
- Cassandra: localhost:9042

**Applications:**
- RabbitMQ UI: http://localhost:15672
- Nextcloud: http://localhost:8088
- Ghost: http://localhost:8089

## Deployment Script Optimization

The included `deploy.sh` script automatically installs Binalyze AIR on containers but includes smart optimization:

- **First startup:** Full Binalyze AIR installation (~30-60 seconds per container)
- **Subsequent restarts:** Instant startup if AIR is already installed (~1-2 seconds per container)
- **Automatic detection:** Checks for `/opt/binalyze/air/agent/air` before installing

This dramatically reduces restart times from ~12 minutes to ~30 seconds for the entire lab environment.

## Container Management

```bash
# Start specific services  
docker-compose up -d nginx postgres nextcloud

# View service logs
docker-compose logs -f nextcloud

# Access a workstation
docker-compose exec workstation-1 /bin/bash

# Check Binalyze AIR installation status
docker-compose exec workstation-1 ls -la /opt/binalyze/air/agent/

# Restart a service
docker-compose restart nginx

# Stop all services
docker-compose down
```

## Configuration

- **Binalyze AIR deployment:** Configure `.env.local` with your deployment URL and token
- **Custom deployment:** Edit `deploy.sh` for service customization
- **Data persistence:** All data is stored in Docker volumes

## System Requirements

- **Minimum:** 8GB RAM, 4 CPU cores, 30GB storage
- **Recommended:** 16GB RAM, 8 CPU cores, 50GB SSD

## Container Hostnames

All containers use capitalized hostnames for easy identification:
- Workstations: WORKSTATION-1 to WORKSTATION-10
- Services: NGINX, HTTPD, TOMCAT, POSTGRES, MONGO, REDIS, CASSANDRA, RABBITMQ, NEXTCLOUD, GHOST

## Data Persistence

The following data persists across container restarts:
- Database data (PostgreSQL, MongoDB, Redis, Cassandra)
- Application data (Nextcloud, Ghost)
- Web server content (Nginx, Apache, Tomcat)
- Message queue data (RabbitMQ)
- Binalyze AIR installation (automatically detected and preserved)

## Troubleshooting

**Container startup issues:**
- Check `.env.local` configuration
- Verify Binalyze AIR deployment URL accessibility
- Monitor logs: `docker-compose logs -f [service-name]`

**Performance optimization:**
- The deployment script automatically skips reinstallation on restarts
- Use `docker-compose restart` instead of `down/up` for faster recovery

## License

This project is provided as-is for educational, development, and security research purposes.