#!/bin/bash
# Bootstrap script for Flatcar Container Linux
# Flatcar is a container-optimized OS, so we run SSM agent as a container

# SSM Agent is typically run as a container on Flatcar
# AWS provides official SSM agent container images
# Reference: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html

# Check if SSM agent container is already running
if ! docker ps | grep -q amazon-ssm-agent; then
  echo "Starting AWS SSM Agent container..."

  # Pull and run the SSM agent container
  docker run -d \
    --name amazon-ssm-agent \
    --restart=always \
    --privileged \
    --net=host \
    -v /var/run/dbus:/var/run/dbus \
    -v /run/systemd:/run/systemd \
    amazon/ssm-agent:latest

  echo "SSM Agent container started successfully"
else
  echo "SSM Agent container is already running"
fi

# Install useful container tools if needed
# Most tools in Flatcar should be run as containers using toolbox
echo "Flatcar Container Linux bootstrap complete"
