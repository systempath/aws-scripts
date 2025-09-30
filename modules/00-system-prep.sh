# shellcheck shell=bash

module_system_prep() {
  log_section "System prep"
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common curl wget git unzip ca-certificates apt-transport-https \
    build-essential pkg-config jq gnupg2 lsb-release ufw fail2ban htop acl

  # Install custom MOTD
  install_template "etc/update-motd.d/10-custom-banner" "/etc/update-motd.d/10-custom-banner" 0755
  # Disable default Ubuntu MOTD parts we don't want
  chmod -x /etc/update-motd.d/10-help-text 2>/dev/null || true
  chmod -x /etc/update-motd.d/50-motd-news 2>/dev/null || true
  chmod -x /etc/update-motd.d/90-updates-available 2>/dev/null || true
}

register_step module_system_prep
