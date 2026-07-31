# Fahrgastrechte-Sammler

Eine selbst gehostete, mobile Webanwendung zur Dokumentation von Zugverspätungen und Zugausfällen. Die Daten können jährlich als CSV oder Excel exportiert und für Fahrgastrechte-Anträge aufbereitet werden.

## Funktionen

- Ersteinrichtung mit eigenem Benutzernamen und Passwort
- Erfassung planmäßiger und tatsächlicher Abfahrts- und Ankunftszeiten
- Vorschläge für bekannte Zugnummern, Bahnhöfe und Störungen
- Mehrfachauswahl in der Übersicht
- ausgewählte Einträge gesammelt löschen
- ausgewählte Einträge als „Entschädigung eingereicht“ markieren
- CSV- und Excel-Export pro Jahr
- automatische Backups vor GitHub-Updates
- persistente Daten direkt im Installationsordner

## Frische Installation aus GitHub

```bash
git clone https://github.com/DEIN-BENUTZERNAME/fahrgastrechte-sammler.git
cd fahrgastrechte-sammler
./install.sh
```

Danach ist die Anwendung standardmäßig erreichbar unter:

```text
http://SERVER-IP:8080
```

Beim ersten Aufruf werden Benutzername und Passwort festgelegt.

## Frische Installation aus einer ZIP

```bash
unzip fahrgastrechte-sammler.zip
cd fahrgastrechte-sammler
./install.sh
```

Die gleiche ZIP kann für eine komplett frische Installation verwendet werden. `install.sh` legt die erforderlichen Verzeichnisse selbst an.

## Persistente Daten

Direkt neben der `docker-compose.yml` werden angelegt:

```text
data/       Datenbank und individueller Secret-Key
backups/    manuelle und automatische Datenbank-Backups
```

Beide Verzeichnisse stehen in `.gitignore` und werden bei einem Update nicht verändert.

## Updates bei Installation per Git

Im Installationsordner ausführen:

```bash
./update.sh
```

Das Skript führt folgende Schritte aus:

1. Datenbank nach `backups/` sichern
2. Änderungen aus dem Branch `main` laden
3. Docker-Image neu bauen
4. Container aktualisiert starten

Lokale Änderungen an versionierten Programmdateien verhindern absichtlich ein unsicheres Git-Update. Eigene Konfiguration gehört in `.env`, `data/` oder `backups/`.

## Updates bei ursprünglicher ZIP-Installation

Konfiguration anlegen:

```bash
cp .env.example .env
```

In `.env` das spätere GitHub-Repository eintragen:

```dotenv
UPDATE_REPOSITORY=https://github.com/DEIN-BENUTZERNAME/fahrgastrechte-sammler.git
UPDATE_BRANCH=main
```

Danach können auch ZIP-Installationen mit folgendem Befehl aktualisiert werden:

```bash
./update.sh
```

Das Skript lädt das Repository temporär und ersetzt ausschließlich Programmdateien. `data/`, `backups/` und `.env` bleiben erhalten.

## Port ändern

Eine `.env` anlegen und beispielsweise eintragen:

```dotenv
APP_PORT=8090
```

Danach neu starten:

```bash
docker compose up -d
```

## Wichtige Befehle

```bash
docker compose ps
docker compose logs --tail=100
docker compose restart
docker compose down
```

Die Datenverzeichnisse sind Bind-Mounts und liegen direkt im Projektordner. Trotzdem sollten `data/` und `backups/` niemals absichtlich gelöscht werden.

## Passwortregel

Mindestens sechs Zeichen sowie mindestens ein Buchstabe, eine Zahl und ein Sonderzeichen.

## GitHub

Das Repository enthält einen GitHub-Actions-Workflow, der bei Pushes und Pull Requests den Docker-Build prüft. Nach dem Anlegen des Repositorys müssen lediglich die Platzhalter in README und `.env.example` durch die echte Repository-Adresse ersetzt werden.
