#!/bin/sh

case "$(arch)" in
  x86_64)
    mkdir /tmp/ssm
    cd /tmp/ssm/
    wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
    sudo dpkg -i amazon-ssm-agent.deb
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    ;;
  aarch64) # Fix value
    mkdir /tmp/ssm
    cd /tmp/ssm/
    wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_arm64/amazon-ssm-agent.deb
    sudo dpkg -i amazon-ssm-agent.deb
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
  ;;
  *)
    echo "Could not identify processor architecture"
    exit 0
esac

curl -fsSL https://code-server.dev/install.sh | sh

