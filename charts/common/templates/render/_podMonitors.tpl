{{/*
Renders the podMonitor objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.podMonitors" -}}
  {{- $rootContext := $ -}}

  {{- $enabledPodMonitors := (include "retsamedoc.common.lib.podMonitor.enabledPodMonitors" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledPodMonitors -}}
    {{- $podMonitorObject := (include "retsamedoc.common.lib.podMonitor.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- include "retsamedoc.common.lib.podMonitor.validate" (dict "rootContext" $rootContext "object" $podMonitorObject) -}}

    {{- include "retsamedoc.common.class.podMonitor" (dict "rootContext" $rootContext "object" $podMonitorObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
