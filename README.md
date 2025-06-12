# AIR Lab Environment

A comprehensive Docker Compose environment for creating a multi-container lab setup with workstations, servers, and applications.

## Overview

This project provides a containerized lab environment with:
- **10 Ubuntu Workstation containers** for general testing and development
- **Web servers** for hosting applications
- **Multiple database systems** for data storage
- **Message queuing** for distributed applications
- **Enterprise applications** for real-world scenarios

Perfect for development, testing, learning, and proof of concepts.

## Services

### Workstations (10 containers)
- **workstation-1** to **workstation-10** - Ubuntu-based development environments

### Web Servers
- **nginx** - Web server (ports 8080, 8443)
- **httpd** - Apache HTTP server (port 8081)
- **tomcat** - Java application server (port 8082)

### Databases
- **mysql** - MySQL database (port 3306)
- **postgres** - PostgreSQL database (port 5432)
- **mongo** - MongoDB NoSQL database (port 27017)
- **redis** - In-memory data store (port 6379)
- **cassandra** - Distributed NoSQL database (ports 9042, 9160)

### Message Queue
- **rabbitmq** - Message broker with web UI (ports 5672, 15672)

### Monitoring
- **grafana** - Visualization platform (port 3000)

### Applications
- **wordpress** - CMS platform (port 8087)
- **nextcloud** - File sharing platform (port 8088)
- **ghost** - Blogging platform (port 8089)

## Quick Start

1. **Start all services**
   ```bash
   docker-compose up -d
   ```

2. **Check status**
   ```bash
   docker-compose ps
   ```

3. **View logs**
   ```bash
   docker-compose logs -f
   ```

## Access Services

**Web Services:**
- Nginx: http://localhost:8080
- Apache: http://localhost:8081
- Tomcat: http://localhost:8082

**Databases:**
- MySQL: localhost:3306
- PostgreSQL: localhost:5432
- MongoDB: localhost:27017
- Redis: localhost:6379
- Cassandra: localhost:9042

**Applications:**
- RabbitMQ UI: http://localhost:15672
- Grafana: http://localhost:3000
- WordPress: http://localhost:8087
- Nextcloud: http://localhost:8088
- Ghost: http://localhost:8089

## Default Credentials

Most services use:
- **Username:** airlab
- **Password:** airlab123

## Container Management

```bash
# Start specific services  
docker-compose up -d nginx mysql wordpress

# View service logs
docker-compose logs -f grafana

# Access a workstation
docker-compose exec workstation-1 /bin/bash

# Restart a service
docker-compose restart nginx

# Stop all services
docker-compose down
```

## Configuration

- **Custom deployment:** Edit `deploy.sh` for service customization
- **Environment variables:** Create `.env.local` for configuration
- **Data persistence:** All data is stored in Docker volumes

## System Requirements

- **Minimum:** 8GB RAM, 4 CPU cores, 20GB storage
- **Recommended:** 16GB RAM, 8 CPU cores, 50GB SSD

## Container Hostnames

All containers use capitalized hostnames:
- Workstations: WORKSTATION-1 to WORKSTATION-10
- Services: NGINX, HTTPD, TOMCAT, MYSQL, POSTGRES, MONGO, REDIS, CASSANDRA, RABBITMQ, GRAFANA, WORDPRESS, NEXTCLOUD, GHOST

## Data Persistence

The following data persists across restarts:
- Database data (MySQL, PostgreSQL, MongoDB, Redis, Cassandra)
- Application data (WordPress, Nextcloud, Ghost, Grafana)
- Web server content (Nginx, Apache, Tomcat)
- Message queue data (RabbitMQ)

## License

This project is provided as-is for educational and development purposes.