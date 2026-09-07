# Spoolman

Helm chart for Spoolman, a filament spool inventory for 3D printers. The web UI and API listen on port 8000. SQLite data is stored at `/home/app/.local/share/spoolman` (enable the data PVC).

Configure via `values.yaml` using this repo’s common library (`retsamedoc.common.*`). Primary targets: k3s + Rancher.
