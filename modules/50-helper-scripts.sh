# shellcheck shell=bash

module_helper_scripts() {
  log_section "Provision helper scripts"

  install_executable "usr-local-bin/start-vite-dev" "/usr/local/bin/start-vite-dev"
  ln -sf /usr/local/bin/start-vite-dev /usr/local/bin/vdev

  install_executable "usr-local-bin/deploy" "/usr/local/bin/deploy"
  install_executable "usr-local-bin/fresh" "/usr/local/bin/fresh"
  install_executable "usr-local-bin/artisan" "/usr/local/bin/artisan"
  install_executable "usr-local-bin/setup-laravel" "/usr/local/bin/setup-laravel"
  install_executable "usr-local-bin/setup-vite-dev" "/usr/local/bin/setup-vite-dev"
  install_executable "usr-local-bin/laravel-fix-perms" "/usr/local/bin/laravel-fix-perms"
  install_executable "usr-local-bin/prepare-repo" "/usr/local/bin/prepare-repo"

  # Install custom MOTD
  install_template "etc/update-motd.d/10-custom-banner" "/etc/update-motd.d/10-custom-banner" 0755
  # Disable default Ubuntu MOTD parts we don't want
  chmod -x /etc/update-motd.d/10-help-text 2>/dev/null || true
  chmod -x /etc/update-motd.d/50-motd-news 2>/dev/null || true
  chmod -x /etc/update-motd.d/90-updates-available 2>/dev/null || true
}

register_step module_helper_scripts
