{{/*
Validate serviceMonitor values
*/}}
{{- define "retsamedoc.common.lib.serviceMonitor.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $serviceMonitorObject := .object -}}

  {{- $enabledServices := (include "retsamedoc.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) -}}

  {{/* Require an explicit target when auto-detect cannot choose uniquely */}}
  {{- if not (eq 1 (len $enabledServices)) -}}
    {{- if and
        (empty (dig "selector" nil $serviceMonitorObject))
        (empty (dig "service" "name" nil $serviceMonitorObject))
        (empty (dig "service" "identifier" nil $serviceMonitorObject))
    -}}
      {{- fail (printf "ServiceMonitor '%s': Either 'service.name' or 'service.identifier' is required because automatic Service detection is not possible (found %d enabled services). Specify the target service explicitly." $serviceMonitorObject.identifier (len $enabledServices)) -}}
    {{- end -}}
  {{- end -}}

  {{- if not $serviceMonitorObject.endpoints -}}
    {{- fail (printf "ServiceMonitor '%s': Endpoints are required. Define at least one endpoint under 'serviceMonitor.%s.endpoints'." $serviceMonitorObject.identifier $serviceMonitorObject.identifier) -}}
  {{- end -}}
{{- end -}}
