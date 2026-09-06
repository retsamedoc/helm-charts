{{/*
Renders the serviceMonitor object required by the chart.
*/}}
{{- define "retsamedoc.common.render.serviceMonitors" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate named serviceMonitors as required */ -}}
  {{- $enabledServiceMonitors := (include "retsamedoc.common.lib.serviceMonitor.enabledServiceMonitors" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledServiceMonitors -}}
    {{- /* Generate object from the raw serviceMonitor values */ -}}
    {{- $serviceMonitorObject := (include "retsamedoc.common.lib.serviceMonitor.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Perform validations on the ServiceMonitor before rendering */ -}}
    {{- include "retsamedoc.common.lib.serviceMonitor.validate" (dict "rootContext" $rootContext "object" $serviceMonitorObject) -}}

    {{- /* Include the ServiceMonitor class */ -}}
    {{- include "retsamedoc.common.class.serviceMonitor" (dict "rootContext" $rootContext "object" $serviceMonitorObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
