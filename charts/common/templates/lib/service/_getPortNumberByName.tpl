{{/*
Return a service port number by name for a Service object
*/}}
{{- define "retsamedoc.common.lib.service.getPortNumberByName" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .serviceID -}}
  {{- $portName := .portName -}}

  {{- $service := include "retsamedoc.common.lib.service.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml -}}

  {{- if $service -}}
    {{ $servicePort := dig "ports" $portName "port" nil $service -}}
    {{- if not (eq $servicePort nil) -}}
      {{- $servicePort -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
