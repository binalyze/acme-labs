#!/bin/bash

# Binalyze AIR deployment script with .env.local support
set -e  # Exit on any error

echo "Starting Binalyze AIR deployment on $(hostname) - $(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"')"

# Check if Binalyze AIR is already installed
if [ -f "/opt/binalyze/air/agent/air" ]; then
    echo "✅ Starting Binalyze AIR Agent service"

    # Start the Binalyze AIR Agent
    service Binalyze.AIR.Agent start

    # Keep the container alive
    tail -f /dev/null
fi

# Function to read .env.local YAML file and extract RESPONDER_PACKAGE_URL from AIR section
get_responder_package_url() {
    if [ ! -f "/app/.env.local" ]; then
        echo "❌ .env.local file not found at /app/.env.local"
        exit 1
    fi
    
    # Read the RESPONDER_PACKAGE_URL from AIR section in YAML format
    local url=$(awk '
        /^AIR:/ { in_air_section=1; next }
        /^[A-Za-z][A-Za-z0-9_]*:/ && !/^AIR:/ { in_air_section=0; next }
        in_air_section && /^[ \t]+RESPONDER_PACKAGE_URL:/ {
            gsub(/^[ \t]+RESPONDER_PACKAGE_URL:[ \t]*/, "")
            gsub(/^["'"'"']|["'"'"']$/, "")
            print
            exit
        }
    ' /app/.env.local)
    
    if [ -z "$url" ]; then
        echo "❌ RESPONDER_PACKAGE_URL not found in AIR section of .env.local"
        exit 1
    fi
    
    echo "$url"
}

# Detect the OS and set package manager
if command -v apt-get &> /dev/null; then
    PACKAGE_MANAGER="apt-get"
    UPDATE_CMD="apt-get update"
    INSTALL_CMD="apt-get install -y"
elif command -v yum &> /dev/null; then
    PACKAGE_MANAGER="yum"
    UPDATE_CMD="yum update -y"
    INSTALL_CMD="yum install -y"
elif command -v dnf &> /dev/null; then
    PACKAGE_MANAGER="dnf"
    UPDATE_CMD="dnf update -y"
    INSTALL_CMD="dnf install -y"
else
    echo "❌ No supported package manager found"
    exit 1
fi

echo "Using package manager: $PACKAGE_MANAGER"

# Update package repositories and install curl and sudo
echo "Updating package repositories and installing dependencies..."
$UPDATE_CMD
$INSTALL_CMD curl sudo

# Get the deployment URL from .env.local
echo "Reading deployment URL from .env.local..."
DEPLOYMENT_URL=$(get_responder_package_url)
echo "Deployment URL: $DEPLOYMENT_URL"

# Deploy Binalyze AIR using the URL from .env.local
echo "Deploying Binalyze AIR..."
curl -kfsSL "$DEPLOYMENT_URL" | sudo sh

# Verify installation
echo "Verifying installation..."
if [ -d "/opt/binalyze/air" ]; then
    echo "✅ Binalyze AIR successfully installed at /opt/binalyze/air"
    ls -la /opt/binalyze/air
else
    echo "❌ Installation failed - /opt/binalyze/air directory not found"
    exit 1
fi

echo "🎉 Deployment completed successfully on container $(hostname)!"
echo "Container is ready and running..."

# Keep the container alive
tail -f /dev/null