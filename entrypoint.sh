#!/bin/sh
set -eu

mkdir -p /data /backups
chmod 700 /data || true
chmod 700 /backups || true

exec "$@"
