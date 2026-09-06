{{/*
Args used by the container.
*/}}
{{- define "retsamedoc.common.lib.container.field.args" -}}
  {{- $ctx := .ctx -}}
  {{- $containerObject := $ctx.containerObject -}}
  {{- $argValues := get $containerObject "args" -}}

  {{- $args := list -}}

  {{- if not (empty $argValues) -}}
    {{- if kindIs "string" $argValues -}}
      {{- $args = append $args $argValues -}}
    {{- else -}}
      {{- $args = $argValues -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $args) -}}
    {{- $args | toYaml -}}
  {{- end -}}
{{- end -}}
