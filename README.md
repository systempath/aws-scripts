<div align="center">
  <img src="https://systempath.com/assets/logo.svg" alt="SystemPath" width="200"/>

  # Ignite

  **Lightning-fast Laravel development environments for AWS EC2**

  Launch production-ready Laravel/Inertia/React + PostgreSQL stacks in minutes. Built by [SystemPath](https://systempath.com).
</div>

---

Ignite provisions Ubuntu EC2 instances with everything you need for modern Laravel development. The provisioning script is auto-generated from modular sources for readability while deploying as a single bootstrap script.

## Quick Start

### Option 1: Direct from GitHub (Recommended)
Use this as EC2 user data or run on an existing Ubuntu instance:

```bash
#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/systempath/ignite/main/dist/ec2-userdata.sh | bash
```

### Option 2: Via Downloader Script
```bash
#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/systempath/ignite/main/aws-ec2-user-data-downloader.sh | bash
```

### Option 3: Customize & Build
```bash
git clone https://github.com/systempath/ignite.git
cd ignite
# Edit config/variables.sh or modules/ as needed
bin/build-userdata
# Use your custom dist/ec2-userdata.sh
```

## What Gets Installed

### Infrastructure & Tools

- **Web Stack**: Nginx, PHP 8.4-FPM, Composer
- **JavaScript**: Node.js 22 (via NVM), pnpm, PM2
- **Database**: PostgreSQL 17, Redis, Adminer
- **Dev Tools**: Mailpit, AWS CLI, GitHub CLI, Claude Code CLI
- **Security**: UFW firewall, Fail2ban, SSH hardening
- **Laravel Helpers**: 20+ commands (`deploy`, `fresh`, `vdev`, etc.)

### Laravel Packages (via `setup-laravel`)

When you run `setup-laravel`, a complete Laravel application is created with:

**Core Framework**
- Laravel 11 with Inertia.js + React starter kit
- Pest testing framework
- Vite for asset building

**Development & Debugging**
- **Laravel Telescope** – Debugging dashboard with request/query/job monitoring
- **Laravel Boost** – Performance optimizations

**Payment Processing**
- **Laravel Cashier** – Stripe subscription billing integration

**AWS Integration**
- **AWS SDK for PHP** – Full AWS service integration (S3, SES, etc.)
- **AWS SDK Laravel Service Provider** – Laravel-specific AWS bindings

**Data & Type Safety**
- **Spatie Laravel Data** – Typed DTOs with validation
- **Spatie TypeScript Transformer** – Generate TypeScript definitions from PHP

**User Management & Authorization**
- **Laravel Pennant** – Feature flags and A/B testing
- **Spatie Laravel Permission** – Role-based access control (RBAC)

**Audit & Logging**
- **Spatie Laravel Activity Log** – Track user actions and model changes

**Media & Files**
- **Spatie Laravel Media Library** – File uploads with image manipulation

**Document Generation**
- **Spatie Laravel PDF** – Generate PDFs from views using Chromium

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
curl -fsSL https://raw.githubusercontent.com/systempath/ignite/main/aws-ec2-user-data-downloader.sh | bash
```

## Important Notes

- **Never run locally** – Script assumes Ubuntu EC2 with root privileges
- **Commit sources** – Commit changes to `modules/` and `templates/`, not generated `dist/`
- **Git config** – No git identity is configured automatically. Run `gkey` after provisioning to optionally set up git user/email
- **Helper scripts** – After provisioning, run `server-help` to see all available commands

---

<div align="center">
  <p>Built with ❤️ by <a href="https://systempath.com">SystemPath</a></p>
  <p><sub>© 2025 SystemPath. All rights reserved.</sub></p>
</div>
