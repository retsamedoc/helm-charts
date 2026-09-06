{{/*
Autodetects the controller for a PodMonitor object
*/}}
{{- define "retsamedoc.common.lib.podMonitor.autoDetectController" -}}
  {{- $rootContext := .rootContext -}}
  {{- $podMonitorObject := .object -}}
  {{- $enabledControllers := (include "retsamedoc.common.lib.controller.enabledControllers" (dict "rootContext" $rootContext) | fromYaml ) -}}

  {{- if eq 1 (len $enabledControllers) -}}
    {{- if and
        (empty (dig "selector" nil $podMonitorObject))
        (empty (dig "controller" "identifier" nil $podMonitorObject))
    -}}
      {{- $_ := set $podMonitorObject "controller" (dict "identifier" ($enabledControllers | keys | first)) -}}
    {{- end -}}
  {{- end -}}

  {{- $podMonitorObject | toYaml -}}
{{- end -}}
