#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$ROOT_DIR"

if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env
  set +a
fi

UPDATE_BRANCH=${UPDATE_BRANCH:-main}
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p data backups

if [ -f data/fahrgastrechte.db ]; then
  cp -p data/fahrgastrechte.db "backups/fahrgastrechte-vor-update-${TIMESTAMP}.db"
  echo "Datenbank-Backup erstellt: backups/fahrgastrechte-vor-update-${TIMESTAMP}.db"
fi

if [ -d .git ]; then
  echo "Aktualisierungen aus Git werden geladen ..."
  git fetch --prune origin "$UPDATE_BRANCH"
  git checkout "$UPDATE_BRANCH"
  git pull --ff-only origin "$UPDATE_BRANCH"
elif [ -n "${UPDATE_REPOSITORY:-}" ] && ! printf '%s' "$UPDATE_REPOSITORY" | grep -q 'DEIN-BENUTZERNAME'; then
  command -v git >/dev/null 2>&1 || { echo "Fehler: git ist auf dem Host nicht installiert." >&2; exit 1; }
  TMP_DIR=$(mktemp -d)
  trap 'rm -rf "$TMP_DIR"' EXIT INT TERM
  echo "Programmdateien werden aus $UPDATE_REPOSITORY geladen ..."
  git clone --depth 1 --branch "$UPDATE_BRANCH" "$UPDATE_REPOSITORY" "$TMP_DIR/repository"
  for item in app Dockerfile docker-compose.yml entrypoint.sh requirements.txt README.md install.sh update.sh .dockerignore .gitignore .env.example; do
    if [ -e "$TMP_DIR/repository/$item" ]; then
      rm -rf "$ROOT_DIR/$item"
      cp -a "$TMP_DIR/repository/$item" "$ROOT_DIR/$item"
    fi
  done
else
  echo "Kein Git-Repository konfiguriert."
  echo "Bei einer Git-Installation: Repository mit 'git clone' installieren."
  echo "Bei einer ZIP-Installation: .env.example nach .env kopieren und UPDATE_REPOSITORY eintragen."
  exit 1
fi

chmod +x install.sh update.sh entrypoint.sh

echo "Container werden mit der neuen Version gebaut ..."
docker compose up -d --build --remove-orphans

echo
echo "Update abgeschlossen."
docker compose ps
