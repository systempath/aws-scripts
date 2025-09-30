# EC2 User Data for Laravel Development

Provision an Ubuntu EC2 instance for Laravel/Inertia/React + PostgreSQL development. The provisioning script is auto-generated from modular sources for readability while deploying as a single bootstrap script.

## Quick Start

### Option 1: Direct from GitHub (Recommended)
Use this as EC2 user data or run on an existing Ubuntu instance:

```bash
#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/systempath/aws-scripts/main/dist/ec2-userdata.sh | bash
```

### Option 2: Via Downloader Script
```bash
#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/systempath/aws-scripts/main/aws-ec2-user-data-downloader.sh | bash
```

### Option 3: Customize & Build
```bash
git clone https://github.com/systempath/aws-scripts.git
cd aws-scripts
# Edit config/variables.sh or modules/ as needed
bin/build-userdata
# Use your custom dist/ec2-userdata.sh
```

## What Gets Installed

- **Web Stack**: Nginx, PHP 8.4-FPM, Composer
- **JavaScript**: Node.js 22 (via NVM), pnpm
- **Database**: PostgreSQL 17, Redis, Adminer
- **Dev Tools**: Mailpit, AWS CLI, GitHub CLI
- **Security**: UFW firewall, Fail2ban, SSH hardening
- **Laravel Helpers**: 20+ commands (`deploy`, `fresh`, `vdev`, etc.)

## Repository Layout

- `modules/` – Ordered setup phases (00-system-prep, 10-system-config, etc.)
- `templates/` – Config files and helper scripts (base64-encoded into dist)
- `config/variables.sh` – Version defaults (PHP, Node, Postgres)
- `config/helpers.sh` – Build utilities
- `bin/build-userdata` – Assembles `dist/ec2-userdata.sh`

## Development Workflow

1. Edit modules in `modules/` or files in `templates/`
2. Run `bin/build-userdata` to regenerate `dist/ec2-userdata.sh`
3. Syntax check: `bash -n dist/ec2-userdata.sh`
4. Test on disposable EC2 instance, review `/var/log/userdata.log`

## Customization

Override defaults via environment variables:

```bash
export PHP_VERSION=8.3
export NODE_VERSION=20
export POSTGRES_VERSION=16
export LARAVEL_AUTO_SETUP=false  # Skip auto Laravel setup
bin/build-userdata
```

Use custom hosted version:

```bash
export USERDATA_URL="https://your-domain.com/custom-userdata.sh"
curl -fsSL https://raw.githubusercontent.com/systempath/aws-scripts/main/aws-ec2-user-data-downloader.sh | bash
```

## Important Notes

- **Never run locally** – Script assumes Ubuntu EC2 with root privileges
- **Commit sources** – Commit changes to `modules/` and `templates/`, not generated `dist/`
- **Git config** – No git identity is configured automatically. Run `gkey` after provisioning to optionally set up git user/email
- **Helper scripts** – After provisioning, run `server-help` to see all available commands
