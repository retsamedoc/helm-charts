# esphome

![Version: 9.0.0](https://img.shields.io/badge/Version-9.0.0-informational?style=flat-square) ![AppVersion: 2024.3.0](https://img.shields.io/badge/AppVersion-2024.3.0-informational?style=flat-square)

ESPHome is a system to control your ESP8266/ESP32 by simple yet powerful configuration files and control them remotely through Home Automation sys

**This chart is not maintained by the upstream project and any issues with the chart should be raised [here](https://github.com/retsamedoc/helm-charts/issues/new/choose)**

## Source Code

* <https://github.com/esphome/esphome>

## Requirements

Kubernetes: `>=1.16.0-0`

## Dependencies

| Repository | Name | Version |
|------------|------|---------|
| https://library-charts.k8s-at-home.com | common | 4.5.2 |

## TL;DR

```console
helm repo add retsamedoc https://retsamedoc.github.io.com/helm-charts/
helm repo update
helm install esphome retsamedoc/esphome
```

## Installing the Chart

To install the chart with the release name `esphome`

```console
helm install esphome retsamedoc/esphome
```

## Uninstalling the Chart

To uninstall the `esphome` deployment

```console
helm uninstall esphome
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.
Other values may be used from the [values.yaml](https://github.com/bjw-s/helm-charts/tree/main/charts/library/common/values.yaml) from the [common library](https://github.com/bjw-s/helm-charts/tree/main/charts/library/common).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install esphome \
  --set env.TZ="America/New York" \
    retsamedoc/esphome
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install esphome retsamedoc/esphome -f values.yaml
```

## Custom configuration

N/A

## Values

**Important**: When deploying an application Helm chart you can add more values from the common library chart [here](https://github.com/bjw-s/helm-charts/tree/main/charts/library/common)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| env | object | See below | environment variables. |
| image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| image.repository | string | `"esphome/esphome"` | image repository |
| image.tag | string | `"2024.3.0"` | image tag |
| ingress.main | object | See values.yaml | Enable and configure ingress settings for the chart under this key. |
| persistence | object | See values.yaml | Configure persistence settings for the chart under this key. |
| service | object | See values.yaml | Configures service settings for the chart. |

## Support

- Open an [issue](https://github.com/retsamedoc/helm-charts/issues/new/choose)

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
