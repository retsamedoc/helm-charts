{{/*
Return a service Object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.service.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledServices := (include "retsamedoc.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledServices $identifier) -}}
    {{- get $enabledServices $identifier | toYaml -}}
  {{- end -}}
{{- end -}}
