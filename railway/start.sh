#!/bin/sh
# First boot: create the gateway config on the volume with a generated dashboard password.
set -e
CFG="${GATEWAY_CONFIG_PATH:-/app/data/gateway.config.yaml}"
mkdir -p "$(dirname "$CFG")" /app/data
if [ ! -f "$CFG" ]; then
  if [ -z "$SIFTGATE_DASHBOARD_PASSWORD" ]; then
    echo "[railway] SIFTGATE_DASHBOARD_PASSWORD is empty; refusing to create a config without a dashboard password" >&2
    exit 1
  fi
  PW=$(printf '%s' "$SIFTGATE_DASHBOARD_PASSWORD" | sed "s/'/''/g")
  sed -e 's/^  port: 2099$/  port: 8080/' \
      -e 's/^  # trust_proxy: false .*$/  trust_proxy: true/' \
      -e 's#^  path: \./data/gateway\.db$#  path: /app/data/gateway.db#' \
      /app/gateway.config.yaml > "$CFG.tmp"
  cat >> "$CFG.tmp" <<YAML

# Added by the Railway template on first boot. The plain-text password below is replaced by its
# bcrypt hash when SiftGate starts. Change it later in the Dashboard or here.
dashboard:
  auth_required: true
  password: '$PW'
  session_secret: "\${env:SIFTGATE_DASHBOARD_SESSION_SECRET}"
YAML
  mv "$CFG.tmp" "$CFG"
  echo "[railway] created $CFG with the dashboard password from SIFTGATE_DASHBOARD_PASSWORD (first boot)"
fi
cd /app
exec node dist/main.js
