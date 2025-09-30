# shellcheck shell=bash

module_system_config() {
  log_section "Swap ${SWAP_SIZE}"
  if [ ! -f /swapfile ]; then
    fallocate -l "${SWAP_SIZE}" /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=2048
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
  fi

  log_section "Sysctl and limits"
  install_template "etc/sysctl/99-hardening.conf" "/etc/sysctl.d/99-hardening.conf"
  sysctl --system
  install_template "etc/security/99-web.conf" "/etc/security/limits.d/99-web.conf"
}

register_step module_system_config
