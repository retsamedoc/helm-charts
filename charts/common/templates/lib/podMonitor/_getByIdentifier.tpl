{{/*
Return a PodMonitor Object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.podMonitor.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledPodMonitors := (include "retsamedoc.common.lib.podMonitor.enabledPodMonitors" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledPodMonitors $identifier) -}}
    {{- $objectValues := get $enabledPodMonitors $identifier -}}
    {{- include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledPodMonitors)) -}}
  {{- end -}}
{{- end -}}
