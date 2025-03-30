# weatherflow2mqtt

![Version: 0.1.2](https://img.shields.io/badge/Version-0.1.2-informational?style=flat-square)

WeatherFlow to MQTT for Home Assistant

**This chart is not maintained by the upstream project and any issues with the chart should be raised [here](https://github.com/retsamedoc/helm-charts/issues/new/choose)**

## Source Code

* <https://github.com/briis/hass-weatherflow2mqtt>

## Requirements

## Dependencies

| Repository | Name | Version |
|------------|------|---------|
| https://library-charts.k8s-at-home.com | common | 4.5.2 |

## TL;DR

```console
helm repo add retsamedoc https://retsamedoc.github.io.com/helm-charts/
helm repo update
helm install weatherflow2mqtt retsamedoc/weatherflow2mqtt
```

## Installing the Chart

To install the chart with the release name `weatherflow2mqtt`

```console
helm install weatherflow2mqtt retsamedoc/weatherflow2mqtt
```

## Uninstalling the Chart

To uninstall the `weatherflow2mqtt` deployment

```console
helm uninstall weatherflow2mqtt
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.
Other values may be used from the [values.yaml](https://github.com/bjw-s/helm-charts/tree/main/charts/library/common/values.yaml) from the [common library](https://github.com/bjw-s/helm-charts/tree/main/charts/library/common).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install weatherflow2mqtt \
  --set env.TZ="America/New York" \
    retsamedoc/weatherflow2mqtt
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install weatherflow2mqtt retsamedoc/weatherflow2mqtt -f values.yaml
```

## Custom configuration

N/A

## Values

**Important**: When deploying an application Helm chart you can add more values from the common library chart [here](https://github.com/bjw-s/helm-charts/tree/main/charts/library/common)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| env | object | See below | environment variables. See more environment variables in the [hass-weatherflow2mqtt repo](https://github.com/briis/hass-weatherflow2mqtt). |
| env.ADD_FORECAST | bool | `false` | retrieve Forecast Data from WeatherFlow. If set to True, STATION_ID and STATION_TOKEN must be filled also. NOTE If this is enabled the component will access the Internet to get the Forecast data. |
| env.DEBUG | string | `"False"` | Enable more debug data in the Container Log.  |
| env.ELEVATION | string | `"0"` | Set the hight above sea level for where the station is placed. This is used when calculating some of the sensor values and should be the station elevation plus device height above ground. The value has to be in meters (meters = feet * 0.3048). |
| env.FORECAST_INTERVAL | string | `"30"` | interval in minutes, between updates of the Forecast data. Default value is 30 minutes. |
| env.LANGUAGE | string | `"en"` | Set the language for Wind Direction cardinals and other sensors with text strings as state value |
| env.LATITUDE | string | `"00.0000"` | Latitude where the Station is located. |
| env.LONGITUDE | string | `"000.0000"` | Longitude where the Station is located. |
| env.MQTT_DEBUG | string | `"False"` | Generate MQTT debugging messages in the log. |
| env.MQTT_HOST | string | `""` | Host name used to connect to the MQTT broker |
| env.MQTT_PASSWORD | string | `nil` | Password used to connect to the MQTT broker |
| env.MQTT_PORT | string | `"1883"` | Port used to connect to the MQTT broker |
| env.MQTT_USERNAME | string | `nil` | User name used to connect to the MQTT broker |
| env.RAPID_WIND_INTERVAL | string | `"0"` | Override when the wind speed and bearing is updated. Default is 0 (as soon as possible) |
| env.STATION_ID | string | `nil` | your Station ID for your WeatherFlow Station. |
| env.STATION_TOKEN | string | `nil` | our personal access Token to allow retrieval of data. If you don't have the token login with your account and create the token. NOTE You must own a WeatherFlow station to get this token |
| env.TZ | string | `"Europe/Copenhagen"` | Set the container timezone |
| env.UNIT_SYSTEM | string | `"metric"` | Set the unit system used Set this to either imperial or metric. |
| env.WF_HOST | string | `"0.0.0.0"` | Host IP used to connect to the weatherflow device. Only change if you have a goofy network setup |
| env.WF_PORT | string | `"50222"` | Port used to connect to the weatherflow device |
| env.ZAMBRETTI_MAX_PRESSURE | string | `"1060"` | All Time High Sea Level Pressure. Default is 1060 (Mb for Metric) or Default is 31.30 (inHG for Imperial) |
| env.ZAMBRETTI_MIN_PRESSURE | string | `"960"` | All Time Low Sea Level Pressure.  Default is 960 (Mb for Metric) or Default is 28.35 (inHG for Imperial)  |
| image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| image.repository | string | `"briis/weatherflow2mqtt"` | image repository |
| image.tag | string | `"3.1.6"` | image tag |
| persistence.data.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.data.enabled | bool | `true` |  |
| persistence.data.mountPath | string | `"/data"` |  |
| persistence.data.size | string | `"1Gi"` |  |
| persistence.data.type | string | `"pvc"` |  |

## Support

- Open an [issue](https://github.com/retsamedoc/helm-charts/issues/new/choose)

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
