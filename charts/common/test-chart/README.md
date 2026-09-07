# common-test

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.0](https://img.shields.io/badge/AppVersion-0.0.0-informational?style=flat-square)

Test wrapper for the common library chart (not published)

**This chart is not maintained by the upstream project and any issues with the chart should be raised [here](https://github.com/retsamedoc/helm-charts/issues/new/choose)**

## Requirements

## Dependencies

| Repository | Name | Version |
|------------|------|---------|
| file://.. | common | 26.9.0 |

## TL;DR

```console
helm repo add retsamedoc https://retsamedoc.github.io/helm-charts/
helm repo update
helm install common-test retsamedoc/common-test
```

## Installing the Chart

To install the chart with the release name `common-test`

```console
helm install common-test retsamedoc/common-test
```

## Uninstalling the Chart

To uninstall the `common-test` deployment

```console
helm uninstall common-test
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.
Other values may be used from the [values.yaml](https://github.com/retsamedoc/helm-charts/tree/main/charts/common/values.yaml) from the [common library](https://github.com/retsamedoc/helm-charts/tree/main/charts/common).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install common-test \
  --set env.TZ="America/New York" \
    retsamedoc/common-test
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install common-test retsamedoc/common-test -f values.yaml
```
