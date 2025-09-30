# shellcheck shell=bash

module_cli_tools() {
  log_section "Developer CLI tools"

  install_executable "usr-local-bin/server-help" "/usr/local/bin/server-help"
  install_executable "usr-local-bin/server-info" "/usr/local/bin/server-info"
  install_executable "usr-local-bin/gkey" "/usr/local/bin/gkey"
  install_executable "usr-local-bin/cloud-log" "/usr/local/bin/cloud-log"
  install_executable "usr-local-bin/tscope" "/usr/local/bin/tscope"
  install_executable "usr-local-bin/mailpit-status" "/usr/local/bin/mailpit-status"
  install_executable "usr-local-bin/backup-database" "/usr/local/bin/backup-database"
  install_executable "usr-local-bin/setup-ssl" "/usr/local/bin/setup-ssl"
  install_executable "usr-local-bin/check-ssl" "/usr/local/bin/check-ssl"

  ln -sf /usr/local/bin/server-help /usr/local/bin/shelp
  ln -sf /usr/local/bin/server-info /usr/local/bin/sinfo
  ln -sf /usr/local/bin/mailpit-status /usr/local/bin/mailpit
  ln -sf /usr/local/bin/mailpit-status /usr/local/bin/mailhog

  append_if_missing "alias shelp='server-help'" /home/ubuntu/.bashrc
  append_if_missing "alias sinfo='server-info'" /home/ubuntu/.bashrc
  append_if_missing "alias vdev='start-vite-dev'" /home/ubuntu/.bashrc
  append_if_missing "alias mailpit='mailpit-status'" /home/ubuntu/.bashrc
  append_if_missing "alias mailhog='mailpit-status'" /home/ubuntu/.bashrc
  append_if_missing "alias artisan='cd /var/www/html && php artisan'" /home/ubuntu/.bashrc
  append_if_missing "alias clog='tail -f /var/log/user-data.log'" /home/ubuntu/.bashrc
  append_if_missing "alias setup-log='cloud-log'" /home/ubuntu/.bashrc
  append_if_missing "alias gkey='gkey'" /home/ubuntu/.bashrc
  append_if_missing "alias tscope='tscope'" /home/ubuntu/.bashrc

  # Set default directory to Laravel project
  append_if_missing "# Auto-navigate to Laravel project" /home/ubuntu/.bashrc
  append_if_missing "[ -d /var/www/html ] && cd /var/www/html" /home/ubuntu/.bashrc

  chown ubuntu:ubuntu /home/ubuntu/.bashrc
}

register_step module_cli_tools
