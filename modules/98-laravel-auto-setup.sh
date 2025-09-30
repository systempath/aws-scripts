# shellcheck shell=bash

module_laravel_auto_setup() {
  log_section "Laravel Auto-Setup"

  if [ "${LARAVEL_AUTO_SETUP}" = "true" ]; then
    echo "Auto-setup enabled - Installing and configuring Laravel application..."

    # Run the setup-laravel script which now handles installation
    echo "Running Laravel setup script..."
    /usr/local/bin/setup-laravel

    echo "Laravel auto-setup complete!"
  else
    echo "Laravel auto-setup is disabled (LARAVEL_AUTO_SETUP=${LARAVEL_AUTO_SETUP})"
    echo "To enable, set LARAVEL_AUTO_SETUP=true when running the user-data script"
    echo "Or run 'sudo setup-laravel' manually after server setup"
  fi
}

register_step module_laravel_auto_setup