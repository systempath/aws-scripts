# shellcheck shell=bash

module_security_hardening() {
  log_section "UFW + Fail2ban"
  ufw --force enable
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow 22/tcp
  ufw allow 80/tcp
  ufw allow 443/tcp
  ufw allow 5173/tcp comment 'Vite dev server'
  ufw allow 8025/tcp comment 'Mailpit web UI'
  ufw allow 8080/tcp comment 'Adminer'
  install_template "etc/fail2ban/jail.local" "/etc/fail2ban/jail.local"
  systemctl enable --now fail2ban

  log_section "SSH hardening"
  local conf=/etc/ssh/sshd_config
  declare -A kv=(
    ["PasswordAuthentication"]="no"
    ["PermitRootLogin"]="no"
    ["PubkeyAuthentication"]="yes"
    ["X11Forwarding"]="no"
    ["ClientAliveInterval"]="300"
    ["ClientAliveCountMax"]="2"
    ["MaxAuthTries"]="3"
    ["MaxSessions"]="10"
  )
  for k in "${!kv[@]}"; do
    if grep -qE "^\\s*${k}\\b" "$conf"; then
      sed -i "s#^\\s*${k}.*#${k} ${kv[$k]}#" "$conf"
    else
      echo "${k} ${kv[$k]}" >>"$conf"
    fi
  done
  systemctl restart ssh || systemctl restart sshd || true
}

register_step module_security_hardening
