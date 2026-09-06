{{/*
Return a ServiceMonitor Object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.serviceMonitor.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledServiceMonitors := (include "retsamedoc.common.lib.serviceMonitor.enabledServiceMonitors" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledServiceMonitors $identifier) -}}
    {{- $objectValues := get $enabledServiceMonitors $identifier -}}
    {{- include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledServiceMonitors)) -}}
  {{- end -}}
{{- end -}}
