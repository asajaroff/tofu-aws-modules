#!/bin/sh

case "$(uname -m)" in
  amd64)
    mkdir -p /tmp/ssm
    cd /tmp/ssm/
    fetch https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/freebsd_amd64/amazon-ssm-agent.pkg
    sudo pkg install -y amazon-ssm-agent.pkg
    sudo sysrc amazon_ssm_agent_enable="YES"
    sudo service amazon-ssm-agent start
    ;;
  arm64|aarch64)
    mkdir -p /tmp/ssm
    cd /tmp/ssm/
    fetch https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/freebsd_arm64/amazon-ssm-agent.pkg
    sudo pkg install -y amazon-ssm-agent.pkg
    sudo sysrc amazon_ssm_agent_enable="YES"
    sudo service amazon-ssm-agent start
  ;;
  *)
    echo "Could not identify processor architecture"
    exit 0
esac
