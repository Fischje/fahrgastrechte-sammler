#!/bin/sh
set -eu

mkdir -p data backups
chmod 700 data backups 2>/dev/null || true

echo "Fahrgastrechte-Sammler wird gebaut und gestartet ..."
docker compose up -d --build

echo
echo "Installation abgeschlossen."
docker compose ps
