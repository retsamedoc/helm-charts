# searxng

![Version: 26.9.0](https://img.shields.io/badge/Version-26.9.0-informational?style=flat-square) ![AppVersion: 2026.9.7-3e454637f](https://img.shields.io/badge/AppVersion-2026.9.7--3e454637f-informational?style=flat-square)

SearXNG is a privacy-respecting metasearch engine. Users are neither tracked nor profiled.

**This chart is not maintained by the upstream project and any issues with the chart should be raised [here](https://github.com/retsamedoc/helm-charts/issues/new/choose)**

## Source Code

* <https://github.com/searxng/searxng>

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
helm install searxng retsamedoc/searxng
```

## Installing the Chart

To install the chart with the release name `searxng`

```console
helm install searxng retsamedoc/searxng
```

## Uninstalling the Chart

To uninstall the `searxng` deployment

```console
helm uninstall searxng
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.
Other values may be used from the [values.yaml](https://github.com/retsamedoc/helm-charts/tree/main/charts/common/values.yaml) from the [common library](https://github.com/retsamedoc/helm-charts/tree/main/charts/common).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install searxng \
  --set controllers.main.containers.main.env.TZ="America/New_York" \
    retsamedoc/searxng
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install searxng retsamedoc/searxng -f values.yaml
```

## Custom configuration

SearXNG listens on **port 8080**. Kubernetes ignores the image `VOLUME` directives, so this chart mounts config and cache itself.

### Base URL

Set the public URL (include the scheme and a trailing slash) so result links and the UI stay correct behind Ingress:

```yaml
controllers:
  main:
    containers:
      main:
        env:
          SEARXNG_BASE_URL: "https://searxng.example.com/"
```

Leave it unset for port-forward only.

### Secret key

Do not commit a production secret. Generate one and pass it as `SEARXNG_SECRET` (this overrides `server.secret_key` in `settings.yml`):

```console
openssl rand -hex 32
```

```yaml
controllers:
  main:
    containers:
      main:
        env:
          SEARXNG_SECRET: "<output of openssl rand -hex 32>"
```

Prefer a Secret and `secretKeyRef` in a private values file. The chart default `secret_key` is a non-secret placeholder so `helm template` succeeds; replace it before exposing the instance.

### settings.yml

A chart-owned ConfigMap is mounted read-only at `/etc/searxng` (`configMaps.settings` / `persistence.settings`). It sets `use_default_settings: true`, turns the Valkey limiter off, and does not require outbound search engines for the process to stay up.

Edit `configMaps.settings.data.settings.yml` for instance name, engines, or `server.method`. The limiter needs Valkey (`SEARXNG_VALKEY_URL`); keep `SEARXNG_LIMITER` / `server.limiter` false unless that service exists.

To let the image write its own `settings.yml` (the entrypoint copies a template and replaces `ultrasecretkey` with a random value), disable the ConfigMap mount and enable the PVC:

```yaml
persistence:
  settings:
    enabled: false
  config:
    enabled: true
```

That PVC is `ReadWriteOnce` at `/etc/searxng`. The controller `strategy` is `Recreate` so two pods do not attach the same volume.

### Cache and ingress

`persistence.cache` is an `emptyDir` at `/var/cache/searxng` (favicon cache). Switch it to `persistentVolumeClaim` if you want that data to survive restarts.

Ingress is off by default. Enable `ingress.main` and set the host (placeholder `searxng.local`, same shape as other charts in this repo). Also set `SEARXNG_BASE_URL` to the external URL.

## Values

**Important**: When deploying an application Helm chart you can add more values from the common library chart [here](https://github.com/retsamedoc/helm-charts/tree/main/charts/common)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMaps | object | See values.yaml | Chart-owned settings.yml. Mounted at /etc/searxng. secret_key is a non-secret placeholder; override it with SEARXNG_SECRET (openssl rand -hex 32). |
| controllers.main.containers.main.env | object | See below | environment variables. |
| controllers.main.containers.main.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| controllers.main.containers.main.image.repository | string | `"docker.io/searxng/searxng"` | image repository |
| controllers.main.containers.main.image.tag | string | `"2026.9.7-3e454637f"` | image tag |
| ingress.main | object | See values.yaml | Enable and configure ingress settings for the chart under this key. |
| persistence | object | See values.yaml | Configure persistence settings for the chart under this key. |
| service | object | See values.yaml | Configures service settings for the chart. Normally this does not need to be modified. |

## Support

- Open an [issue](https://github.com/retsamedoc/helm-charts/issues/new/choose)

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
