# shellcheck shell=bash

module_node_runtime() {
  log_section "Node.js ${NODE_VERSION} via NVM"

  echo "Removing conflicting Node.js packages..."
  apt-mark unhold nodejs npm 2>/dev/null || true
  DEBIAN_FRONTEND=noninteractive apt-get remove -y nodejs npm node-* libnode* 2>/dev/null || true
  DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
  DEBIAN_FRONTEND=noninteractive apt-get clean

  DEBIAN_FRONTEND=noninteractive apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    python3-dev \
    make \
    g++ \
    gcc \
    build-essential

  echo "Installing NVM for ubuntu user..."
  # Install NVM as the ubuntu user (NOT as root)
  su - ubuntu -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash'

  echo "Installing Node.js ${NODE_VERSION} as ubuntu user..."
  # Install Node.js and global packages as ubuntu user
  su - ubuntu -c "
    export NVM_DIR=\"\$HOME/.nvm\"
    [ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"

    nvm install ${NODE_VERSION}
    nvm use ${NODE_VERSION}
    nvm alias default ${NODE_VERSION}

    echo \"Installed Node.js version: \$(node -v)\"
    echo \"NPM version: \$(npm -v)\"

    echo \"Installing global packages...\"
    npm install -g pm2 corepack @anthropic-ai/claude-code

    # Enable corepack for yarn and pnpm
    corepack enable

    echo \"Global packages installed\"
  "

  echo "Creating system-wide symlinks..."
  # Find the actual Node.js installation directory
  # This avoids using su in a loop which can hang
  NODE_BIN_DIR=$(find /home/ubuntu/.nvm/versions/node -type d -name bin 2>/dev/null | head -1)

  if [ -n "${NODE_BIN_DIR}" ] && [ -d "${NODE_BIN_DIR}" ]; then
    echo "Found Node.js bin directory: ${NODE_BIN_DIR}"

    # Create symlinks for all binaries in the Node bin directory
    for bin_file in "${NODE_BIN_DIR}"/*; do
      if [ -f "$bin_file" ] && [ -x "$bin_file" ]; then
        bin_name=$(basename "$bin_file")
        ln -sf "$bin_file" "/usr/local/bin/$bin_name"

        # Show progress for important binaries
        if [[ "$bin_name" =~ ^(node|npm|npx|pm2|claude|yarn|pnpm)$ ]]; then
          echo "Linked $bin_name -> $bin_file"
        fi
      fi
    done

    echo "Symlinks created successfully"
  else
    echo "Warning: Could not find Node.js bin directory in /home/ubuntu/.nvm/versions/node"
    echo "Attempting fallback method..."

    # Fallback: try to find based on expected version
    NODE_PATH="/home/ubuntu/.nvm/versions/node/v${NODE_VERSION}"
    if [ -d "${NODE_PATH}/bin" ]; then
      NODE_BIN_DIR="${NODE_PATH}/bin"
      echo "Found Node.js bin directory via fallback: ${NODE_BIN_DIR}"

      for bin_file in "${NODE_BIN_DIR}"/*; do
        if [ -f "$bin_file" ] && [ -x "$bin_file" ]; then
          bin_name=$(basename "$bin_file")
          ln -sf "$bin_file" "/usr/local/bin/$bin_name"
        fi
      done
    else
      echo "Error: Could not create symlinks. Node.js may need manual configuration."
    fi
  fi

  # Setup NVM in ubuntu user's bashrc
  echo "Configuring ubuntu user's bash environment..."
  append_if_missing 'export NVM_DIR="$HOME/.nvm"' /home/ubuntu/.bashrc
  append_if_missing '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' /home/ubuntu/.bashrc
  append_if_missing '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' /home/ubuntu/.bashrc
  chown ubuntu:ubuntu /home/ubuntu/.bashrc

  # Install NVM profile script for all users (optional - for awareness)
  cat > /etc/profile.d/nvm-notice.sh << 'EOF'
#!/bin/sh
# NVM is installed for the ubuntu user
# To use Node.js as another user, either:
# 1. Use the symlinks in /usr/local/bin (node, npm, pm2, claude, etc.)
# 2. Install NVM for your user: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
EOF
  chmod 755 /etc/profile.d/nvm-notice.sh

  echo "=== Verification ==="
  echo "Node (via symlink): $(node -v 2>/dev/null || echo 'not found')"
  echo "NPM (via symlink): $(npm -v 2>/dev/null || echo 'not found')"
  echo "PM2 (via symlink): $(pm2 -v 2>/dev/null || echo 'not found')"
  echo "Claude (via symlink): $(claude --version 2>/dev/null || echo 'not found')"

  # Verify as ubuntu user
  su - ubuntu -c "
    source ~/.nvm/nvm.sh
    echo \"Node (ubuntu user): \$(node -v 2>/dev/null || echo 'not found')\"
    echo \"Claude (ubuntu user): \$(claude --version 2>/dev/null || echo 'not found')\"
  "

  echo "Node.js installation complete!"
}

register_step module_node_runtime