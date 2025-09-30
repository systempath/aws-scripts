<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://systempath.com/assets/logo.svg">
    <img src="https://systempath.com/assets/logo.svg" alt="SystemPath" width="180"/>
  </picture>

  # 🔥 Ignite

  ### *Zero to production-ready Laravel in under 5 minutes*

  <p>
    <strong>Ignite</strong> is the fastest way to launch battle-tested Laravel environments on AWS EC2.<br/>
    One command. Full stack. Zero config.
  </p>

  <p>
    <a href="#-quick-start"><strong>Get Started »</strong></a>
  </p>

  <sub>Built with precision by <a href="https://systempath.com">SystemPath</a></sub>

</div>

<br/>

## ✨ What Makes Ignite Different

**Ignite isn't just another provisioning script.** It's a complete, production-grade Laravel development environment that deploys in minutes—not hours.

- 🚀 **One-Command Deploy** – Paste a single line into EC2 user data and walk away
- 🏗️ **Battle-Tested Stack** – Laravel 11, Inertia, React, PostgreSQL 17, Redis, Nginx
- 🔐 **Security First** – SSH hardening, UFW firewall, Fail2ban, automatic SSL with Let's Encrypt
- 🛠️ **20+ Helper Commands** – `deploy`, `fresh`, `vdev`, and more for instant productivity
- 📦 **Smart Package Selection** – Stripe, AWS SDK, Spatie suite, TypeScript transformers—pre-configured
- 🎯 **Modular & Hackable** – Don't like our choices? Fork it, customize it, rebuild it

## 🚀 Quick Start

### → Launch New EC2 Instance

Paste this as **User Data** when launching an Ubuntu EC2 instance:

```bash
#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/systempath/ignite/main/dist/ec2-userdata.sh | bash
```

**That's it.** SSH in 5 minutes later to a fully configured Laravel environment.

---

### → Provision Existing Instance

Already have an Ubuntu server? Run this:

```bash
curl -fsSL https://raw.githubusercontent.com/systempath/ignite/main/dist/ec2-userdata.sh | sudo bash
```

---

### → Customize & Build Your Own

Want to tweak the stack? Fork and modify:

```bash
git clone https://github.com/systempath/ignite.git
cd ignite
# Edit config/variables.sh or modules/ as needed
bin/build-userdata
# Deploy your custom dist/ec2-userdata.sh
```

## 📦 What's Inside

### 🏗️ Infrastructure & Tools

| Component | Version | Purpose |
|-----------|---------|---------|
| **Nginx** | Latest | High-performance web server |
| **PHP-FPM** | 8.4 | Modern PHP with opcache & JIT |
| **Node.js** | 22 (via NVM) | JavaScript runtime for Vite/React |
| **PostgreSQL** | 17 | Powerful relational database |
| **Redis** | Latest | Fast caching & session store |
| **pnpm** | Latest | Fast, disk-efficient package manager |
| **Composer** | Latest | PHP dependency manager |

### 🔐 Security & DevOps

- **UFW Firewall** – Ports 22, 80, 443, 8025, 8080 only
- **Fail2ban** – Automatic SSH intrusion prevention
- **SSH Hardening** – Key-only auth, no root login
- **Let's Encrypt** – Automatic SSL with `setup-ssl` command
- **Claude Code CLI** – AI-powered development assistant

### ⚡ Laravel Helpers (20+ Commands)

- `deploy` – Full deployment pipeline (migrate, build, optimize)
- `fresh` – Quick rebuild without migrations
- `vdev` – Start Vite dev server with HMR
- `gkey` – Display GitHub deploy key
- `setup-ssl` – Configure Let's Encrypt SSL
- `backup-database` – Manual PostgreSQL backup
- `tscope` – Laravel Telescope dashboard info
- `mailpit` – Email testing interface info

### 🎨 Laravel Stack (via `setup-laravel`)

When you run `setup-laravel`, you get a complete Laravel 11 application with:

<table>
  <tr>
    <td width="50%">

**🎯 Core Framework**
- Inertia.js + React starter kit
- Pest testing framework
- Vite asset building

**🔍 Development & Debugging**
- Laravel Telescope
- Laravel Boost

**💳 Payment Processing**
- Laravel Cashier (Stripe)

**☁️ AWS Integration**
- AWS SDK for PHP
- Laravel service provider

</td>
<td width="50%">

**🎭 Type Safety & Data**
- Spatie Laravel Data (DTOs)
- TypeScript Transformer

**👥 Users & Permissions**
- Laravel Pennant (feature flags)
- Spatie Laravel Permission (RBAC)

**📊 Audit & Logging**
- Spatie Activity Log

**📁 Media & Documents**
- Spatie Media Library
- Spatie Laravel PDF

</td>
</tr>
</table>

## 🏛️ Architecture

Ignite uses a modular build system that compiles separate components into a single deployment script:

```
ignite/
├── modules/        # Ordered setup phases (00-system-prep → 999-finalize)
├── templates/      # Config files & helper scripts (base64-encoded)
├── config/         # Version defaults & build utilities
├── bin/            # Build script
└── dist/           # Generated ec2-userdata.sh (don't edit directly)
```

**Key principle:** Edit sources in `modules/` and `templates/`, never the generated `dist/` file.

## 🛠️ Development Workflow

Contributing or customizing? Follow this workflow:

1. **Edit** – Modify modules in `modules/` or files in `templates/`
2. **Build** – Run `bin/build-userdata` to regenerate `dist/ec2-userdata.sh`
3. **Validate** – Syntax check with `bash -n dist/ec2-userdata.sh`
4. **Test** – Deploy to disposable EC2, monitor `/var/log/userdata.log`
5. **Commit** – Commit source changes, not generated files

## ⚙️ Customization

### Override Version Defaults

```bash
export PHP_VERSION=8.3
export NODE_VERSION=20
export POSTGRES_VERSION=16
export LARAVEL_AUTO_SETUP=false  # Skip automatic Laravel setup
bin/build-userdata
```

### Use Self-Hosted Script

```bash
export USERDATA_URL="https://your-domain.com/custom-userdata.sh"
curl -fsSL https://raw.githubusercontent.com/systempath/ignite/main/aws-ec2-user-data-downloader.sh | bash
```

## ⚠️ Important Notes

- ⛔ **Never run locally** – Script assumes Ubuntu EC2 with root privileges
- 📝 **Commit sources only** – Commit changes to `modules/` and `templates/`, not `dist/`
- 🔑 **Git setup** – Run `gkey` after provisioning to configure git identity
- 📚 **Learn the helpers** – Run `server-help` or `shelp` to see all available commands
- 🔍 **Monitor setup** – Watch progress with `tail -f /var/log/userdata.log`

## 🤝 Support & Contributing

Found a bug? Have a feature request? [Open an issue](https://github.com/systempath/ignite/issues).

Want to contribute? PRs welcome! Please read our development workflow above.

---

<div align="center">

  **[SystemPath](https://systempath.com)** • *Building tools that ship faster*

  <sub>© 2025 SystemPath. All rights reserved.</sub>

</div>
