#!/bin/bash
#
# Custom Bootstrap Script Example for Debian-based EC2 Instances
# This script runs before cloud-config and is useful for:
# - Installing system agents (like AWS SSM Agent)
# - Setting up repositories
# - Performing architecture-specific installations
# - Any early-stage system configuration
#

set -e  # Exit on error
set -x  # Print commands for debugging

echo "Starting custom bootstrap script..."

# Detect the processor architecture
ARCH=$(arch)
echo "Detected architecture: $ARCH"

# Example: Install AWS SSM Agent (optional, comment out if not needed)
case "$ARCH" in
  x86_64)
    echo "Installing SSM Agent for x86_64..."
    mkdir -p /tmp/ssm
    cd /tmp/ssm/
    wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
    sudo dpkg -i amazon-ssm-agent.deb
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    ;;
  aarch64)
    echo "Installing SSM Agent for ARM64..."
    mkdir -p /tmp/ssm
    cd /tmp/ssm/
    wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_arm64/amazon-ssm-agent.deb
    sudo dpkg -i amazon-ssm-agent.deb
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    ;;
  *)
    echo "Warning: Could not identify processor architecture"
    ;;
esac

# Example: Add custom APT repositories
# echo "Adding custom repository..."
# curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Example: Install specific kernel modules
# modprobe <module_name>

# Example: Configure system settings
# sysctl -w net.ipv4.ip_forward=1

# Example: Download and install custom binaries
# wget https://example.com/my-binary -O /usr/local/bin/my-binary
# chmod +x /usr/local/bin/my-binary

echo "Custom bootstrap script completed successfully!"
