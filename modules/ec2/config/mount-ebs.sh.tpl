#!/bin/bash
set -e

echo "Mounting additional EBS volumes..."

%{~ for vol in volumes ~}
# Mount ${vol.mount_point}
echo "Processing ${vol.device_name} -> ${vol.mount_point}"

# Wait for device to be available
for i in {1..30}; do
  if [ -b "${vol.device_name}" ]; then
    echo "Device ${vol.device_name} is available"
    break
  fi
  echo "Waiting for device ${vol.device_name}... ($i/30)"
  sleep 2
done

if [ ! -b "${vol.device_name}" ]; then
  echo "ERROR: Device ${vol.device_name} not found after 60 seconds"
  exit 1
fi

# Create mount point
mkdir -p ${vol.mount_point}

# Check if device already has a filesystem
if blkid ${vol.device_name} > /dev/null 2>&1; then
  echo "Filesystem already exists on ${vol.device_name}"
else
  echo "Creating ${vol.filesystem_type} filesystem on ${vol.device_name}"
  mkfs.${vol.filesystem_type} ${vol.device_name}
fi

# Mount the volume
if ! mountpoint -q ${vol.mount_point}; then
  mount ${vol.device_name} ${vol.mount_point}
  echo "Mounted ${vol.device_name} to ${vol.mount_point}"
else
  echo "${vol.mount_point} is already mounted"
fi

# Add to fstab if not already there (using UUID for reliability)
DEVICE_UUID=$(blkid -s UUID -o value ${vol.device_name})
if ! grep -q "$DEVICE_UUID" /etc/fstab; then
  echo "UUID=$DEVICE_UUID ${vol.mount_point} ${vol.filesystem_type} defaults,nofail 0 2" >> /etc/fstab
  echo "Added ${vol.device_name} to /etc/fstab with UUID=$DEVICE_UUID"
else
  echo "${vol.device_name} already in /etc/fstab"
fi

%{~ endfor ~}

echo "All EBS volumes mounted successfully"
df -h
