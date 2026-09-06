{{/*
Command used by the container.
*/}}
{{- define "retsamedoc.common.lib.container.field.command" -}}
  {{- $ctx := .ctx -}}
  {{- $containerObject := $ctx.containerObject -}}
  {{- $commandValues := get $containerObject "command" -}}

  {{- $command := list -}}

  {{- if not (empty $commandValues) -}}
    {{- if kindIs "string" $commandValues -}}
      {{- $command = append $command $commandValues -}}
    {{- else -}}
      {{- $command = $commandValues -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $command) -}}
    {{- $command | toYaml -}}
  {{- end -}}
{{- end -}}
