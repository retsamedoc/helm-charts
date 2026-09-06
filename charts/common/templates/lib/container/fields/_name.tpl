{{/*
Name used by the container.
*/}}
{{- define "retsamedoc.common.lib.container.field.name" -}}
  {{- $ctx := .ctx -}}
  {{- $rootContext := $ctx.rootContext -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- /* Default to container identifier */ -}}
  {{- $name := $containerObject.identifier -}}

  {{- if hasKey $containerObject "nameOverride" -}}
    {{- $option := get $containerObject "nameOverride" -}}
    {{- if not (empty $option) -}}
      {{- $name = $option -}}
    {{- end -}}
  {{- end -}}

  {{- /* Parse any templates */ -}}
  {{- $name = tpl $name $rootContext -}}

  {{- $name | toYaml -}}
{{- end -}}
