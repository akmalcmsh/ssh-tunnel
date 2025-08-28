#!/usr/bin/env bash

set -euo pipefail
umask 077

: "${REMOTE_HOST:?REMOTE_HOST is required}"
: "${REMOTE_USER:=system}"
: "${REMOTE_PORT:=5432}"
: "${LOCAL_PORT:=6996}"

USE_SSHPASS=${USE_SSHPASS:-}

SSH_OPTS=(
  -o ExitOnForwardFailure=yes
  -o ServerAliveInterval=30
  -o ServerAliveCountMax=3
  -o StrictHostKeyChecking=accept-new
  -N
  -L "${LOCAL_PORT}:127.0.0.1:${REMOTE_PORT}"
)

if [[ -n "${USE_SSHPASS}" ]]; then
  : "${REMOTE_PASS:?REMOTE_PASS is required when USE_SSHPASS is set}"
  command -v sshpass >/dev/null 2>&1 || { echo "[ERROR] sshpass not installed" >&2; exit 1; }
  exec sshpass -p "${REMOTE_PASS}" ssh -o PreferredAuthentications=password "${SSH_OPTS[@]}" "${REMOTE_USER}@${REMOTE_HOST}"
else
  exec ssh "${SSH_OPTS[@]}" "${REMOTE_USER}@${REMOTE_HOST}"
fi