# Melodious

Reverse proxy for a Melodious (Harmony Hub Control) web UI that already runs on a rooted Logitech Harmony Hub. This chart does not install or root the hub; set `hub.host` to the hub’s LAN address and enable Ingress (or a Gateway API Route) to reach the UI through Traefik.

Primary targets: k3s managed by Rancher. See the chart README for install and configuration.
