# SearXNG

Privacy-respecting metasearch engine. Queries are sent to public search engines and results are aggregated without tracking or profiling.

HTTP on port 8080. Configure via `values.yaml` (image, env, service, ingress, settings ConfigMap, persistence at `/etc/searxng` and `/var/cache/searxng`). Primary targets: k3s + Rancher.
