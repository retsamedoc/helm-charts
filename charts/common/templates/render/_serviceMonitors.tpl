{{/*
Renders the serviceMonitor object required by the chart.
*/}}
{{- define "retsamedoc.common.render.serviceMonitors" -}}
  {{- $rootContext := $ -}}

  {{- $enabledServiceMonitors := (include "retsamedoc.common.lib.serviceMonitor.enabledServiceMonitors" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledServiceMonitors -}}
    {{- $serviceMonitorObject := (include "retsamedoc.common.lib.serviceMonitor.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- include "retsamedoc.common.lib.serviceMonitor.validate" (dict "rootContext" $rootContext "object" $serviceMonitorObject) -}}

    {{- include "retsamedoc.common.class.serviceMonitor" (dict "rootContext" $rootContext "object" $serviceMonitorObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
