# shellcheck shell=bash

module_nginx_setup() {
  log_section "Nginx install"
  DEBIAN_FRONTEND=noninteractive apt-get install -y nginx

  mkdir -p /var/www
  chown -R ubuntu:www-data /var/www
  chmod 2775 /var/www

  install_template "etc/profile.d/umask-002.sh" "/etc/profile.d/umask-002.sh"
  install_template "etc/nginx/gzip.conf" "/etc/nginx/conf.d/gzip.conf"
  install_template "etc/nginx/sites-available_default" "/etc/nginx/sites-available/default"

  ensure_dir /var/www/placeholder
  render_template "var/www/placeholder_index.html" > /var/www/placeholder/index.html
  chmod 0644 /var/www/placeholder/index.html
  chown -R www-data:www-data /var/www/placeholder
}

register_step module_nginx_setup
