# Repository Guidelines

## Project Structure & Module Organization
- Root-level `aws-ec2-user-data-downloader.sh` fetches the latest provisioning bundle from S3 and hands off execution on first boot.
- `ec2-userdata.sh` is the canonical provisioning playbook; it streams to `/var/log/userdata.log` and orchestrates package installs, security hardening, and helper commands like `setup-laravel`.
- `README.md` captures operator quick-start notes—keep it aligned with script behavior every time provisioning flow changes.

## Build, Test, and Development Commands
- `bash -n ec2-userdata.sh`: run a syntax check before committing.
- `shellcheck ec2-userdata.sh aws-ec2-user-data-downloader.sh`: lint both scripts; silence warnings only with documented justification.
- `rg --context 3 'TODO'`: surface unfinished work inside the scripts for triage.
- Never execute the provisioning scripts on local machines; they assume an EC2 Ubuntu host with root privileges.

## Coding Style & Naming Conventions
- Stick to POSIX-compatible Bash with `#!/bin/bash` and `set -euo pipefail` near the top.
- Indent blocks with two spaces, align multiline continuations, and prefer lowercase underscore-separated helper names.
- Constants such as `PHP_VERSION` stay in uppercase snake_case; temporary variables remain lowercase.
- When editing heredocs, keep descriptive delimiters (`NGINX`, `EOF_SWAPPABLE`) and sort directives for repeatability.

## Testing Guidelines
- Validate changes on disposable Ubuntu LTS EC2 instances; collect `/var/log/userdata.log` and notable command output for review.
- For partial checks, comment or guard cloud-dependent sections with environment toggles (e.g., `if [[ "${DRY_RUN:-0}" = 1 ]]; then ... fi`).
- Confirm helper commands (`server-help`, `setup-laravel`) after each iteration and document observed differences in the pull request notes.

## Commit & Pull Request Guidelines
- Write imperative commit messages referencing the touched script (`tighten ufw rules`, `document Claude sync`).
- PRs must outline behavioral changes, required IAM or security updates, and include logs/screenshots from a successful EC2 run.
- Flag high-risk areas (network exposure, credential handling) and list follow-up items or rollback steps when necessary.

## Security & Configuration Tips
- Keep the S3 object private, rotate keys after sensitive edits, and ensure download commands use `curl -fsSL` or `aws s3 cp --no-sign-request` only for public assets.
- Never store secrets in the repo; rely on AWS Parameter Store or Secrets Manager and document prerequisites in the PR template.
