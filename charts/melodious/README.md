# melodious

![Version: 26.11.0](https://img.shields.io/badge/Version-26.11.0-informational?style=flat-square) ![AppVersion: 1.27-alpine](https://img.shields.io/badge/AppVersion-1.27--alpine-informational?style=flat-square)

Reverse proxy to a Melodious (Harmony Hub Control) web UI on a rooted Logitech Harmony Hub

**This chart is not maintained by the upstream project and any issues with the chart should be raised [here](https://github.com/retsamedoc/helm-charts/issues/new/choose)**

## Source Code

* <https://github.com/schlambos/harmony-hub-control>

## Requirements

Kubernetes: `>=1.31.0-0`

## Dependencies

| Repository | Name | Version |
|------------|------|---------|
| file://../common | common | 26.9.0 |

## TL;DR

```console
helm repo add retsamedoc https://retsamedoc.github.io/helm-charts/
helm repo update
helm install melodious retsamedoc/melodious
```

## Installing the Chart

To install the chart with the release name `melodious`

```console
helm install melodious retsamedoc/melodious
```

## Uninstalling the Chart

To uninstall the `melodious` deployment

```console
helm uninstall melodious
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.
Other values may be used from the [values.yaml](https://github.com/retsamedoc/helm-charts/tree/main/charts/common/values.yaml) from the [common library](https://github.com/retsamedoc/helm-charts/tree/main/charts/common).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install melodious \
  --set env.TZ="America/New York" \
    retsamedoc/melodious
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install melodious retsamedoc/melodious -f values.yaml
```

## Custom configuration

Melodious’s dashboard runs **on the Harmony Hub** (`hub.host`:`hub.port`, default port 8080). This chart only runs an in-cluster nginx reverse proxy so Traefik (Ingress) or Gateway API can front that LAN device:

`Client → Traefik → Service → nginx Pod → Hub`

1. Install Melodious on the hub with the [upstream Setup Wizard / CLI / Unraid Docker](https://github.com/schlambos/harmony-hub-control) (out of band).
2. Set `hub.host` to a LAN IP or hostname reachable from your k3s nodes.
3. Enable `ingress.main` (or a common-library `route`) toward this chart’s Service on port 8080.

Keep the hub on a trusted network. The hub UI is plain HTTP; enable Melodious **System → Web UI sign-in** if untrusted clients can reach the Ingress. Do not expose hub SSH or the hub’s own `:8080` to the internet.

### Advanced: Traefik without a proxy Pod

You can point Traefik at the hub with a selector-less Service plus Endpoints / EndpointSlice via common [`rawResources`](https://github.com/retsamedoc/helm-charts/tree/main/charts/common). Prefer this chart’s nginx proxy by default — Traefik versions differ on Endpoints vs EndpointSlice, and ExternalName needs DNS rather than a raw IP.

## Values

**Important**: When deploying an application Helm chart you can add more values from the common library chart [here](https://github.com/retsamedoc/helm-charts/tree/main/charts/common)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMaps | object | See values.yaml | nginx reverse-proxy config. Helm-templated; uses hub.host / hub.port. |
| controllers.main.containers.main.env | object | See below | environment variables. |
| controllers.main.containers.main.env.TZ | string | `"UTC"` | Set the container timezone |
| controllers.main.containers.main.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| controllers.main.containers.main.image.repository | string | `"nginx"` | image repository |
| controllers.main.containers.main.image.tag | string | Chart.yaml appVersion | image tag |
| controllers.main.strategy | string | `"Recreate"` |  |
| hub | object | See below | Harmony Hub running Melodious. Must be reachable from cluster nodes on the LAN. |
| hub.host | string | `""` | Hub IP or hostname (no scheme/port). Required for a working proxy. |
| hub.port | int | `8080` | Hub web UI port (Melodious default is 8080). |
| ingress.main | object | See values.yaml | Enable and configure ingress settings for the chart under this key. |
| persistence.nginx.defaultMode | int | `292` |  |
| persistence.nginx.enabled | bool | `true` |  |
| persistence.nginx.globalMounts[0].path | string | `"/etc/nginx/nginx.conf"` |  |
| persistence.nginx.globalMounts[0].readOnly | bool | `true` |  |
| persistence.nginx.globalMounts[0].subPath | string | `"nginx.conf"` |  |
| persistence.nginx.identifier | string | `"nginx"` |  |
| persistence.nginx.type | string | `"configMap"` |  |
| service | object | See values.yaml | Configures service settings for the chart. Normally this does not need to be modified. |

## Support

- Open an [issue](https://github.com/retsamedoc/helm-charts/issues/new/choose)

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
