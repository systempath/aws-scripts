# shellcheck shell=bash

module_database_stack() {
  log_section "PostgreSQL ${POSTGRES_VERSION}"
  install -d -m0755 /etc/apt/keyrings
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/keyrings/postgresql.gpg
  echo "deb [signed-by=/etc/apt/keyrings/postgresql.gpg] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" >/etc/apt/sources.list.d/pgdg.list
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql-${POSTGRES_VERSION} postgresql-client-${POSTGRES_VERSION} postgresql-contrib-${POSTGRES_VERSION} postgresql-common postgresql-client-common

  install -d -m0755 /etc/postgresql/${POSTGRES_VERSION}/main/conf.d
  install_template "etc/postgresql/99-tuning.conf" "/etc/postgresql/${POSTGRES_VERSION}/main/conf.d/99-tuning.conf"

  systemctl enable --now postgresql

  DB_NAME="laravel"
  DB_USER="laravel"
  DB_PASS="$(openssl rand -base64 24)"
  sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='${DB_USER}'" | grep -q 1 || sudo -u postgres psql -v ON_ERROR_STOP=1 -c "CREATE USER ${DB_USER} WITH ENCRYPTED PASSWORD '${DB_PASS}';"
  sudo -u postgres psql -lqt | cut -d '|' -f1 | grep -qw ${DB_NAME} || sudo -u postgres createdb -O ${DB_USER} ${DB_NAME}
  sudo -u postgres psql -d ${DB_NAME} -v ON_ERROR_STOP=1 -c 'CREATE EXTENSION IF NOT EXISTS pgcrypto;'
  sudo -u postgres psql -d ${DB_NAME} -v ON_ERROR_STOP=1 -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'

  cat > /home/ubuntu/.db_credentials <<EOF_CREDS
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=${DB_NAME}
DB_USERNAME=${DB_USER}
DB_PASSWORD=${DB_PASS}
EOF_CREDS
  chown ubuntu:ubuntu /home/ubuntu/.db_credentials
  chmod 600 /home/ubuntu/.db_credentials

  log_section "Adminer setup"
  mkdir -p /var/www/adminer
  curl -fsSL https://www.adminer.org/latest.php -o /var/www/adminer/index.php
  chown -R www-data:www-data /var/www/adminer
  install_template "etc/nginx/adminer.conf" "/etc/nginx/sites-available/adminer"
  ln -sf /etc/nginx/sites-available/adminer /etc/nginx/sites-enabled/adminer
}

register_step module_database_stack
