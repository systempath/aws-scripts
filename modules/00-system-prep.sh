# shellcheck shell=bash

module_system_prep() {
  log_section "System prep"
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common curl wget git unzip ca-certificates apt-transport-https \
    build-essential pkg-config jq gnupg2 lsb-release ufw fail2ban htop acl
}

register_step module_system_prep
