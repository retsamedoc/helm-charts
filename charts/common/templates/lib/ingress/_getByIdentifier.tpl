{{/*
Return an Ingress Object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.ingress.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}

  {{- $enabledIngresses := (include "retsamedoc.common.lib.ingress.enabledIngresses" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledIngresses $identifier) -}}
    {{- get $enabledIngresses $identifier | toYaml -}}
  {{- end -}}
{{- end -}}
