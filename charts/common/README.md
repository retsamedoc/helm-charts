# common

![Version: 26.9.0](https://img.shields.io/badge/Version-26.9.0-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

Function library for Helm charts in this repository.

## Source Code

- <https://github.com/retsamedoc/helm-charts/tree/main/charts/common>

## Requirements

Kubernetes: `>=1.31.0-0`

## Installing the Chart

This is a [Helm Library Chart](https://helm.sh/docs/topics/library_charts/#helm).

**This chart is not meant to be installed directly.** It is hidden from the Rancher Apps catalog (`catalog.cattle.io/hidden`).

## Using this library

Include this chart as a dependency in your `Chart.yaml`:

```yaml
# Chart.yaml
dependencies:
  - name: common
    version: 26.9.0
    repository: https://retsamedoc.github.io/helm-charts
    # Local development:
    # repository: file://../common
```

In templates, use the `retsamedoc.common.*` helpers, for example:

```yaml
{{- include "retsamedoc.common.loader.init" . }}
{{- include "retsamedoc.common.loader.generate" . }}
```

### Gateway API

Values under `route:` (HTTPRoute by default, plus GRPCRoute / TCPRoute / TLSRoute / UDPRoute) and `backendTLSPolicy:` render Gateway API resources. **Install the Gateway API CRDs on the cluster** — they are not part of stock k3s. Cluster `Gateway` / `GatewayClass` objects stay operational concerns; app charts attach via `route.*.parentRefs`.

### NetworkPolicy key

Use top-level **`networkPolicy`** (singular). This intentionally differs from some upstream charts that used `networkpolicies`.

## Testing

```bash
helm dependency update charts/common/test-chart
helm unittest -f 'unittests/*_test.yaml' charts/common/test-chart
```

## License

Same as this repository: Apache-2.0 (see the root `LICENSE`).
