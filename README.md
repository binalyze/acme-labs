# AIR Lab Environment

A comprehensive Docker Compose environment for creating a multi-container lab setup with workstations, servers, and business applications. This environment provides a complete infrastructure for testing, development, and learning purposes.

## Overview

This project provides a containerized lab environment with:
- **10 Ubuntu Workstation containers** for general testing and development
- **15 Debian-based Server containers** providing various infrastructure services
- **5 Business Application containers** running modern open-source applications

Perfect for:
- **Development and testing** across multiple environments
- **Learning** server administration and application deployment
- **Proof of concepts** and prototyping
- **Load testing** and performance analysis
- **Security testing** and penetration testing labs

## Environment Components

### Workstation Containers (Ubuntu-based)
- **air-workstation-1** through **air-workstation-10**
- Ubuntu latest with privileged access
- Custom deployment script execution
- Isolated environments for testing

### Server Containers (Debian-based)
- **air-server-nginx** - Nginx web server (ports 8080, 8443)
- **air-server-apache** - Apache HTTP server (port 8081)
- **air-server-tomcat** - Apache Tomcat application server (port 8082)
- **air-server-postgresql** - PostgreSQL database (port 5432)
- **air-server-mysql** - MySQL database (port 3306)
- **air-server-redis** - Redis cache/data store (port 6379)
- **air-server-memcached** - Memcached caching system (port 11211)
- **air-server-mongodb** - MongoDB NoSQL database (port 27017)
- **air-server-rabbitmq** - RabbitMQ message broker with management UI (ports 5672, 15672)
- **air-server-fileserver** - HTTP static file server (port 8095)
- **air-server-mailserver** - Complete mail server solution (ports 25, 143, 587, 993)
- **air-server-ldap** - OpenLDAP directory server (ports 389, 636)
- **air-server-dns** - BIND9 DNS server (ports 53, 953)
- **air-server-time** - NTP time synchronization server (port 123)
- **air-server-perl** - Perl application server with HTTP interface (port 8096)

### Business Application Containers
- **air-app-nextcloud** - File sharing and collaboration platform (port 8085)
- **air-app-grafana** - Monitoring and visualization (port 8087)
- **air-app-wikijs** - Modern wiki platform (port 8090)
- **air-app-keycloak** - Identity and access management (port 8092)
- **air-app-portainer** - Container management UI (ports 8093, 8094)

## Prerequisites

- Docker and Docker Compose installed
- Sufficient system resources (30+ containers require adequate CPU/memory)
- At least 8GB RAM and 4+ CPU cores recommended
- 20+ GB available disk space

## Quick Start

1. **Clone this repository**
   ```bash
   git clone <repository-url>
   cd air-lab-environment
   ```

2. **Create your environment configuration (if using workstations)**
   ```bash
   # Only needed if you plan to use the workstation deployment functionality
   cp .env.local.example .env.local
   # Edit .env.local with your configuration
   ```

3. **Start all containers**
   ```bash
   docker-compose up -d
   ```

4. **Monitor startup progress**
   ```bash
   docker-compose logs -f
   ```

## Usage

### Starting the Environment

```bash
# Start all containers
docker-compose up -d

# Start only workstations
docker-compose up -d $(docker-compose config --services | grep workstation)

# Start only servers
docker-compose up -d $(docker-compose config --services | grep server)

# Start only applications
docker-compose up -d $(docker-compose config --services | grep app)

# Start specific containers
docker-compose up -d air-server-nginx air-server-mysql air-app-nextcloud
```

### Accessing Services

Once started, services are available at:

**Web Servers:**
- Nginx: http://localhost:8080, https://localhost:8443
- Apache: http://localhost:8081
- Tomcat: http://localhost:8082
- File Server: http://localhost:8095
- Perl Server: http://localhost:8096

**Databases:**
- PostgreSQL: localhost:5432 (user: airlab, password: airlab123)
- MySQL: localhost:3306 (user: airlab, password: airlab123)
- MongoDB: localhost:27017 (user: airlab, password: airlab123)

**Caching & Messaging:**
- Redis: localhost:6379
- Memcached: localhost:11211
- RabbitMQ: localhost:5672, Management UI: http://localhost:15672

**Mail & Directory Services:**
- Mail Server: SMTP:25, IMAP:143, Submission:587, IMAPS:993
- LDAP: localhost:389, LDAPS:636 (admin password: airlab123)

**Network Services:**
- DNS Server: localhost:53 (UDP/TCP), RNDC:953 (management)
- Time Server (NTP): localhost:123 (UDP)

**Business Applications:**
- Nextcloud: http://localhost:8085
- Grafana: http://localhost:8087 (admin: airlab/airlab123)
- Wiki.js: http://localhost:8090
- Keycloak: http://localhost:8092 (admin: airlab/airlab123)
- Portainer: http://localhost:8093, https://localhost:8094

### Container Management

```bash
# View all container status
docker-compose ps

# View logs from all containers
docker-compose logs -f

# View logs from specific container
docker-compose logs -f air-app-nextcloud

# Execute commands in a container
docker-compose exec air-workstation-1 /bin/bash
docker-compose exec air-server-nginx /bin/bash

# Restart specific services
docker-compose restart air-server-postgresql air-app-grafana

# Stop all containers
docker-compose down

# Stop and remove all data
docker-compose down -v
```

## Container Details

### Container Features
- **Custom hostnames**: Each container has a hostname matching its service name
- **Persistent data**: Databases and applications use Docker volumes for data persistence
- **Auto-restart**: Containers restart automatically unless manually stopped
- **Integrated networking**: All containers can communicate with each other by hostname
- **Deploy script execution**: All containers execute your custom deploy.sh script on startup

### Default Credentials
Most services use consistent default credentials:
- **Username**: airlab
- **Password**: airlab123

### Data Persistence
The following data is persisted across container restarts:
- PostgreSQL data
- MySQL data
- MongoDB data
- Redis data
- RabbitMQ data
- File server data
- Mail server data and configuration
- LDAP directory data
- DNS zone files and configuration
- Perl application data
- All application data (Nextcloud, Grafana, Wiki.js, etc.)

## Development and Customization

### Adding New Services

To add a new service, edit `docker-compose.yml`:

```yaml
air-server-newservice:
  image: newservice:latest
  container_name: air-server-newservice
  hostname: air-server-newservice
  ports:
    - "8097:8080"
  environment:
    - ENV_VAR=value
  volumes:
    - newservice_data:/data
    - ./deploy.sh:/app/deploy.sh:ro
    - ./.env.local:/app/.env.local:ro
  command: /bin/bash -c "bash /app/deploy.sh & service-start-command"
  restart: unless-stopped
```

Don't forget to add the volume to the volumes section:

```yaml
volumes:
  # ... existing volumes ...
  newservice_data:
```

### Customizing Configurations

- **Environment variables**: Modify the `environment` sections in `docker-compose.yml`
- **Port mappings**: Change the `ports` mappings to avoid conflicts
- **Resource limits**: Add `deploy.resources` sections for memory/CPU limits
- **Deploy script**: Modify `deploy.sh` to customize what gets executed on each container

## System Requirements

### Recommended Specifications
- **CPU**: 8+ cores
- **RAM**: 16+ GB
- **Storage**: 50+ GB SSD
- **Network**: Stable internet connection

### Resource Usage (Approximate)
- **Workstations**: 100-200 MB RAM each
- **Servers**: 200-500 MB RAM each
- **Applications**: 300-1000 MB RAM each
- **Total**: 10-14 GB RAM when all containers are running

## Troubleshooting

### Common Issues

**Port conflicts:**
```bash
# Check if ports are already in use
netstat -tulpn | grep :8080

# Modify port mappings in docker-compose.yml if needed
```

**Container startup failures:**
```bash
# Check container logs
docker-compose logs container-name

# Check system resources
docker stats
```

**Database connection issues:**
```bash
# Ensure database containers are running
docker-compose ps | grep postgres

# Check database logs
docker-compose logs air-server-postgresql
```

**Application not accessible:**
```bash
# Verify container is running
docker-compose ps

# Check port mapping
docker-compose port air-app-nextcloud 80
```

**Deploy script permission issues:**
```bash
# Check if deploy.sh is executable on host
chmod +x deploy.sh

# Or check container logs for permission errors
docker-compose logs air-server-nginx | grep deploy
```

**DNS resolution issues:**
```bash
# Test DNS server functionality
dig @localhost example.com

# Check DNS server logs
docker-compose logs air-server-dns
```

**Time synchronization issues:**
```bash
# Check NTP server status
ntpq -p localhost

# Verify time server logs
docker-compose logs air-server-time
```

### Performance Optimization

```bash
# Start only needed services
docker-compose up -d air-server-nginx air-server-postgresql air-app-nextcloud

# Monitor resource usage
docker stats

# Clean up unused resources
docker system prune -f
docker volume prune -f
```

## Security Considerations

- **Default credentials**: Change default passwords in production
- **Network exposure**: Services are exposed on localhost only by default
- **Privileged containers**: Workstation containers run in privileged mode
- **Volume mounts**: Some containers mount Docker socket (Portainer)
- **Mail server security**: Mail server includes spam protection and security features
- **LDAP security**: LDAP server supports both encrypted and unencrypted connections
- **DNS security**: DNS server provides authoritative and recursive resolution
- **Time server security**: NTP server uses SYS_TIME capability for system time management

For production use:
- Use custom credentials for all services
- Implement proper network segmentation
- Regular security updates
- Monitor container logs
- Configure proper SSL/TLS certificates
- Implement proper firewall rules
- Secure DNS zone configurations
- Configure NTP authentication if needed

## Service Integration

### DNS Integration
The DNS server (air-server-dns) provides name resolution for the lab environment:
- **Authoritative DNS**: Configure custom zones for lab domains
- **Recursive DNS**: Resolve external domain names
- **RNDC Management**: Use port 953 for DNS server control
- **Zone Files**: Stored in persistent volumes

### LDAP Integration
The LDAP server (air-server-ldap) can be used for authentication with other services:
- **Domain**: airlab.local
- **Base DN**: dc=airlab,dc=local
- **Admin User**: cn=admin,dc=airlab,dc=local
- **Admin Password**: airlab123

### Mail Server Features
The mail server includes:
- **Anti-spam**: SpamAssassin enabled
- **Anti-virus**: ClamAV scanning
- **Security**: Fail2Ban protection
- **Greylisting**: Postgrey enabled

### Time Synchronization
The NTP server (air-server-time) provides:
- **Network Time Protocol**: Accurate time synchronization
- **External Sync**: Synchronizes with pool.ntp.org
- **Local Network**: Serves time to other lab containers

### Perl Development Environment
The Perl server (air-server-perl) offers:
- **HTTP Server**: Built-in web server for Perl applications
- **Development Environment**: Full Perl 5.38 runtime
- **Application Hosting**: Serve Perl web applications
- **Persistent Storage**: Store applications in `/app` directory

### Monitoring Integration
Use Grafana (air-app-grafana) to monitor:
- Container metrics via Portainer
- DNS query statistics
- NTP synchronization status
- Application metrics from various services

## Support and Contributing

- **Issues**: Report issues with specific container logs and system information
- **Features**: Submit feature requests for additional services or improvements
- **Contributions**: Pull requests welcome for additional services or improvements

## License

This project is provided as-is for educational and development purposes.