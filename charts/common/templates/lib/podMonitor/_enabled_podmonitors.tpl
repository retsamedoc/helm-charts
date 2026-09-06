{{/*
Return the enabled podMonitors.
*/}}
{{- define "retsamedoc.common.lib.podMonitor.enabledPodMonitors" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledPodMonitors := dict -}}

  {{- range $identifier, $podMonitor := $rootContext.Values.podMonitor -}}
    {{- if kindIs "map" $podMonitor -}}
      {{- $podMonitorEnabled := true -}}
      {{- if hasKey $podMonitor "enabled" -}}
        {{- $podMonitorEnabled = $podMonitor.enabled -}}
      {{- end -}}

      {{- if $podMonitorEnabled -}}
        {{- $_ := set $enabledPodMonitors $identifier . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- range $identifier, $objectValues := $enabledPodMonitors -}}
    {{- $object := include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledPodMonitors)) | fromYaml -}}
    {{- $object = include "retsamedoc.common.lib.podMonitor.autoDetectController" (dict "rootContext" $rootContext "object" $object) | fromYaml -}}
    {{- $_ := set $enabledPodMonitors $identifier $object -}}
  {{- end -}}

  {{- $enabledPodMonitors | toYaml -}}
{{- end -}}
