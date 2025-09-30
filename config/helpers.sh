# shellcheck shell=bash

RUN_STEPS=()

log_section() {
  echo "=== $* ==="
}

ensure_dir() {
  local dir=$1
  mkdir -p "$dir"
}

render_template() {
  local key=$1
  payload_b64 "$key" | base64 --decode
}

install_template() {
  local key=$1
  local dest=$2
  local mode=${3:-0644}
  ensure_dir "$(dirname "$dest")"
  render_template "$key" >"$dest"
  chmod "$mode" "$dest"
}

install_executable() {
  local key=$1
  local dest=$2
  install_template "$key" "$dest" 0755
}

append_if_missing() {
  local line=$1
  local file=$2
  touch "$file"
  if ! grep -Fxq "$line" "$file"; then
    echo "$line" >> "$file"
  fi
}

register_step() {
  RUN_STEPS+=("$1")
}

run_registered_steps() {
  local step
  for step in "${RUN_STEPS[@]}"; do
    "$step"
  done
}
