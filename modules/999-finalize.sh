# shellcheck shell=bash

module_finalize_and_reboot() {
  log_section "System Finalization"

  # Run final system updates to catch any security patches
  echo "Running final system updates..."
  DEBIAN_FRONTEND=noninteractive apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
  DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
  DEBIAN_FRONTEND=noninteractive apt-get autoclean

  echo ""
  echo "===================================================="
  echo "✅ SERVER SETUP COMPLETE!"
  echo "===================================================="

  # Show appropriate message based on Laravel installation
  if [ "${LARAVEL_AUTO_SETUP}" = "true" ]; then
    echo ""
    echo "🎉 Laravel application fully installed and configured!"
    echo "   Location: /var/www/html"
    echo "   URL: http://$(curl -s ifconfig.me 2>/dev/null || echo 'your-ip')"
  else
    echo ""
    echo "📦 Server ready for Laravel installation"
    echo "   To install: sudo setup-laravel"
  fi

  echo ""
  echo "🔄 REBOOTING SERVER IN 30 SECONDS..."
  echo ""
  echo "This reboot is required to:"
  echo "  • Apply kernel and security updates"
  echo "  • Initialize Node.js/NVM environment properly"
  echo "  • Start all services with optimized configurations"
  echo "  • Clear OPcache with new PHP settings"
  echo "  • Apply firewall and security hardening"
  echo ""
  echo "After reboot:"
  echo "  • SSH back in - you'll be in /var/www/html automatically"
  echo "  • Run 'server-info' to check system status"
  echo "  • Run 'server-help' to see available commands"

  if [ "${LARAVEL_AUTO_SETUP}" = "true" ]; then
    echo "  • Your Laravel app will be running at http://$(curl -s ifconfig.me 2>/dev/null || echo 'your-ip')"
    echo "  • Run 'vdev' to start the Vite development server"
  else
    echo "  • Run 'sudo setup-laravel' to install Laravel"
  fi

  echo "===================================================="

  # Log the reboot
  echo "$(date): Initiating automatic reboot after setup completion (Laravel auto-setup: ${LARAVEL_AUTO_SETUP})" >> /var/log/user-data.log

  # Schedule reboot in 30 seconds to allow the script to finish cleanly
  # Using 'nohup' and background to ensure the command persists
  nohup bash -c "sleep 30 && reboot" &>/dev/null &

  # Give user time to see the message
  sleep 5

  echo ""
  echo "📝 Setup log: /var/log/user-data.log"
  echo "🔄 Reboot scheduled..."
  echo ""
}

register_step module_finalize_and_reboot
