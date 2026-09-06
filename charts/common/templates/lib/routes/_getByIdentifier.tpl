{{/*
Return a Route object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.route.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}

  {{- $enabledRoutes := (include "retsamedoc.common.lib.route.enabledRoutes" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledRoutes $identifier) -}}
    {{- get $enabledRoutes $identifier | toYaml -}}
  {{- end -}}
{{- end -}}
