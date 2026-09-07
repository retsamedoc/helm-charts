# RomM

Self-hosted ROM manager and player (image `ghcr.io/rommapp/romm:5.2.0`).

Optional bundled MariaDB (`mariadb.enabled`), or point `DB_*` at an external database. Valkey is internal (`/redis-data`). Set `ROMM_AUTH_SECRET_KEY` from a Secret. Primary targets: k3s + Rancher.
