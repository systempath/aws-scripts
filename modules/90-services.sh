# shellcheck shell=bash

module_services() {
  log_section "Redis"
  DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server
  sed -i 's/^#\?maxmemory .*/maxmemory 256mb/' /etc/redis/redis.conf || echo "maxmemory 256mb" >>/etc/redis/redis.conf
  sed -i 's/^#\?maxmemory-policy .*/maxmemory-policy allkeys-lru/' /etc/redis/redis.conf || echo "maxmemory-policy allkeys-lru" >>/etc/redis/redis.conf
  systemctl enable --now redis-server

  log_section "Mailpit (Email Testing)"
  if ! curl -sL --connect-timeout 30 --max-time 60 https://raw.githubusercontent.com/axllent/mailpit/develop/install.sh | sudo bash; then
    echo "Warning: Mailpit installation had issues, but continuing with setup..."
  else
    echo "Mailpit installed successfully"
  fi

  if [ -f /usr/local/bin/mailpit ]; then
    install_template "etc/systemd/mailpit.service" "/etc/systemd/system/mailpit.service"
    mkdir -p /var/lib/mailpit
    chown nobody:nogroup /var/lib/mailpit
    systemctl daemon-reload
    systemctl enable --now mailpit
    echo "Mailpit service enabled and started"
  else
    echo "Warning: Mailpit binary not found at /usr/local/bin/mailpit"
  fi

  log_section "Supervisor"
  DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor
  systemctl enable --now supervisor
  install_template "etc/supervisor/laravel-worker.conf" "/etc/supervisor/conf.d/laravel-worker.conf"
  supervisorctl reread
  supervisorctl update

  log_section "Cron jobs"
  install_template "etc/cron/laravel-schedule" "/etc/cron.d/laravel-schedule"
  install_template "etc/cron/database-backup" "/etc/cron.d/database-backup"

  log_section "AWS CLI v2"
  tmpdir="$(mktemp -d)"
  cd "$tmpdir"
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
  unzip -q awscliv2.zip
  ./aws/install
  cd /
  rm -rf "$tmpdir"

  log_section "Nginx reload"
  nginx -t
  systemctl restart nginx
}

register_step module_services
