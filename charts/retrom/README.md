# Retrom

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![AppVersion: 0.7.14](https://img.shields.io/badge/AppVersion-0.7.14-informational?style=flat-square)

Retrom is a centralized game library/collection management service with a focus on emulation

**This chart is not maintained by the upstream project and any issues with the chart should be raised [here](https://github.com/retsamedoc/helm-charts/issues/new/choose)**

## Source Code

* <https://github.com/JMBeresford/retrom>
* <https://github.com/retsamedoc/helm-charts/tree/main/charts/retrom>


## Requirements

Kubernetes: `>=1.16.0-0`

## Dependencies

| Repository | Name | Version |
|------------|------|---------|
| https://library-charts.k8s-at-home.com | common | 4.3.0 |

## TL;DR

```console
helm repo add retsamedoc https://retsamedoc.github.io/helm-charts
helm repo update
helm install retrom retsamedoc/retrom
```

## Installing the Chart

To install the chart with the release name `Retrom`

```console
helm install retrom retsamedoc/retrom
```

## Uninstalling the Chart

To uninstall the `retrom` deployment

```console
helm uninstall retrom
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.
Other values may be used from the [values.yaml](https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common/values.yaml) from the [common library](https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install retrom \
  --set env.TZ="America/New York" \
    retsamedoc/retrom
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install Retrom retsamedoc/retrom -f values.yaml
```

## Custom configuration

If you plan to use networked storage to store your media or config for Retrom, (NFS, etc.) please take a look at the
Fast Access option in the Retrom settings. This will help improve the performance of the application
by not constantly monitoring media folders.

## Values

**Important**: When deploying an application Helm chart you can add more values from our common library chart [here](https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enableServiceLinks | bool | `false` | Enable Kubernetes service links. Disabled by default, since Retrom_* environment vars potentially clash with the application. |
| env | object | See below | environment variables. |
| env.CONTEXT_PATH | string | `nil` | Used to set the base path for reverse proxies eg. /Retrom, /music, etc. |
| env.JAVA_OPTS | string | `nil` | For passing additional java options. For some reverse proxies, you may need to pass `JAVA_OPTS=-Dserver.use-forward-headers=true` for Retrom to generate the proper URL schemes. |
| env.TZ | string | `"UTC"` | Set the container timezone |
| image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| image.repository | string | `"Retromadvanced/Retrom-advanced"` | image repository |
| image.tag | string | `"latest@sha256:f7cbafac28063dce99b443037547b4fe40ae270b7bc5e47efea9bb5d6751ca9d"` | image tag The specific digest is for the `amd64` image, but arm compatible images are also available. |
| ingress.main | object | See values.yaml | Enable and configure ingress settings for the chart under this key. |
| persistence | object | See values.yaml | Configure persistence settings for the chart under this key. |
| probes | object | See values.yaml | Configures the probes for the main Pod. |
| service | object | See values.yaml | Configures service settings for the chart. Normally this does not need to be modified. |

## Changelog

### Version 0.0.1

#### Added

N/A

#### Changed

N/A

#### Fixed

N/A

### Older versions

A historical overview of changes can be found on [ArtifactHUB](https://artifacthub.io/packages/helm/retsamedoc/retrom?modal=changelog)

## Support

- Open an [issue](https://github.com/k8s-at-home/charts/issues/new/choose)
