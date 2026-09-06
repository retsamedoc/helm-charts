{{/*
Renders the podMonitor objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.podMonitors" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate named podMonitors as required */ -}}
  {{- $enabledPodMonitors := (include "retsamedoc.common.lib.podMonitor.enabledPodMonitors" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledPodMonitors -}}
    {{- /* Generate object from the raw podMonitor values */ -}}
    {{- $podMonitorObject := (include "retsamedoc.common.lib.podMonitor.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Perform validations on the PodMonitor before rendering */ -}}
    {{- include "retsamedoc.common.lib.podMonitor.validate" (dict "rootContext" $rootContext "object" $podMonitorObject) -}}

    {{- /* Include the PodMonitor class */ -}}
    {{- include "retsamedoc.common.class.podMonitor" (dict "rootContext" $rootContext "object" $podMonitorObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
