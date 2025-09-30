# shellcheck shell=bash

module_php_stack() {
  log_section "PHP ${PHP_VERSION}"
  add-apt-repository -y ppa:ondrej/php
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    php${PHP_VERSION}-fpm php${PHP_VERSION}-cli php${PHP_VERSION}-common \
    php${PHP_VERSION}-pgsql php${PHP_VERSION}-sqlite3 php${PHP_VERSION}-curl \
    php${PHP_VERSION}-mbstring php${PHP_VERSION}-xml php${PHP_VERSION}-zip \
    php${PHP_VERSION}-gd php${PHP_VERSION}-bcmath php${PHP_VERSION}-intl \
    php${PHP_VERSION}-readline php${PHP_VERSION}-imagick php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-redis php${PHP_VERSION}-pcov

  install_template "etc/php/fpm_pool_www.conf" "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"
  sed -i "s/__PHP_VERSION__/${PHP_VERSION}/g" "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"

  install_template "etc/php/fpm_conf_zz-custom.ini" "/etc/php/${PHP_VERSION}/fpm/conf.d/zz-custom.ini"

  log_section "Configuring inotify watchers for development tools"
  echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf
  echo "fs.inotify.max_user_instances=512" >> /etc/sysctl.conf
  sysctl -p

  sed -i 's/^memory_limit = .*/memory_limit = 256M/' /etc/php/${PHP_VERSION}/cli/php.ini
  sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 64M/' /etc/php/${PHP_VERSION}/cli/php.ini
  sed -i 's/^post_max_size = .*/post_max_size = 64M/' /etc/php/${PHP_VERSION}/cli/php.ini
  sed -i 's/^max_execution_time = .*/max_execution_time = 300/' /etc/php/${PHP_VERSION}/cli/php.ini

  systemctl enable --now php${PHP_VERSION}-fpm
  ln -sf /run/php/php${PHP_VERSION}-fpm.sock /run/php/php-fpm.sock

  log_section "Composer + Laravel installer"
  export HOME=/root COMPOSER_HOME=/root/.composer
  EXPECTED_CHECKSUM="$(curl -fsSL https://composer.github.io/installer.sig)"
  php -r "copy('https://getcomposer.org/installer','composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r 'echo hash_file("sha384","composer-setup.php");')"
  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
    echo "Composer installer checksum mismatch"; rm composer-setup.php; exit 1
  fi
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer
  rm composer-setup.php

  sudo -u ubuntu -H /usr/local/bin/composer global require laravel/installer

  install_template "etc/profile.d/composer-path.sh" "/etc/profile.d/composer-path.sh"

  if [ -x /home/ubuntu/.config/composer/vendor/bin/laravel ]; then
    ln -sf /home/ubuntu/.config/composer/vendor/bin/laravel /usr/local/bin/laravel
  elif [ -x /home/ubuntu/.composer/vendor/bin/laravel ]; then
    ln -sf /home/ubuntu/.composer/vendor/bin/laravel /usr/local/bin/laravel
  fi
}

register_step module_php_stack
