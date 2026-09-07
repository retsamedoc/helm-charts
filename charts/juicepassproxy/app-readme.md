# JuicePassProxy

Proxy UDP traffic between Juicebox EV chargers and MQTT for Home Assistant discovery.

Uses this repository’s common library (`retsamedoc.common.*`, `controllers` / `service` values). Primary targets: k3s + Rancher.

On k3s Traefik you usually need a UDP entrypoint (`HelmChartConfig` for Traefik) plus an `IngressRouteUDP` to this chart’s Service on port 8047 — see the chart README Custom configuration section. You can also use hostNetwork / NodePort / LoadBalancer UDP instead.
