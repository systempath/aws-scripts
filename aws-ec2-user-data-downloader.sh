#!/bin/bash
# EC2 User Data Downloader
# Downloads and executes the provisioning script from GitHub (or custom URL)
# Override with: export USERDATA_URL="https://your-custom-url/ec2-userdata.sh"

USERDATA_URL="${USERDATA_URL:-https://raw.githubusercontent.com/systempath/aws-scripts/main/dist/ec2-userdata.sh}"

curl -fsSL "$USERDATA_URL" -o /tmp/setup.sh
chmod +x /tmp/setup.sh
/tmp/setup.sh 2>&1 | tee /var/log/user-data.log
