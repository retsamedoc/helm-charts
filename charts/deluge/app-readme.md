# Deluge

Lightweight BitTorrent client (image `linuxserver/deluge:2.2.0`).

Web UI is on port 8112. Inbound torrent traffic is TCP and UDP 6881. Persist `/config` and mount a downloads path at `/downloads`. Primary targets: k3s + Rancher.
