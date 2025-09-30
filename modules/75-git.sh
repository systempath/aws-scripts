# shellcheck shell=bash

module_git_setup() {
  log_section "Git & GitHub Configuration"

  DEBIAN_FRONTEND=noninteractive apt-get install -y git

  if [ ! -f /home/ubuntu/.ssh/github_deploy_key ]; then
    sudo -u ubuntu mkdir -p /home/ubuntu/.ssh
    sudo -u ubuntu ssh-keygen -t ed25519 -f /home/ubuntu/.ssh/github_deploy_key -C "deploy@$(hostname)-$(date +%Y%m%d)" -N ""
    chmod 700 /home/ubuntu/.ssh
    chmod 600 /home/ubuntu/.ssh/github_deploy_key
    chmod 644 /home/ubuntu/.ssh/github_deploy_key.pub
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
  fi

  ensure_dir /home/ubuntu/.ssh
  local ssh_config=/home/ubuntu/.ssh/config
  if ! [ -f "$ssh_config" ] || ! grep -q "Host github.com" "$ssh_config"; then
    cat <<'CFG' >> "$ssh_config"
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_deploy_key
    IdentitiesOnly yes
    StrictHostKeyChecking accept-new
CFG
    chmod 600 "$ssh_config"
    chown ubuntu:ubuntu "$ssh_config"
  fi

  sudo -u ubuntu ssh-keyscan -t ed25519 github.com >> /home/ubuntu/.ssh/known_hosts 2>/dev/null

  sudo -u ubuntu git config --global init.defaultBranch main
  sudo -u ubuntu git config --global pull.rebase false
  sudo -u ubuntu git config --global credential.helper 'cache --timeout=3600'

  echo "GitHub deploy key generated. Use 'gkey' command to view it and configure git identity."
}

register_step module_git_setup
