# shellcheck shell=bash

# Default versions and sizing. Allow overrides via environment when building or running.
: "${SWAP_SIZE:=2G}"
: "${PHP_VERSION:=8.4}"
: "${NODE_VERSION:=22}"
: "${POSTGRES_VERSION:=17}"
: "${LARAVEL_AUTO_SETUP:=true}"
