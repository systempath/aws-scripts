# shellcheck shell=bash

module_ssl_tooling() {
  log_section "SSL/Certbot Setup"
  DEBIAN_FRONTEND=noninteractive apt-get install -y certbot python3-certbot-nginx
  install_template "etc/letsencrypt/01-reload-nginx" "/etc/letsencrypt/renewal-hooks/deploy/01-reload-nginx" 0755
}

register_step module_ssl_tooling
