{{/*
Image used by the container.
*/}}
{{- define "retsamedoc.common.lib.container.field.image" -}}
  {{- $ctx := .ctx -}}
  {{- $rootContext := $ctx.rootContext -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- include "retsamedoc.common.lib.imageSpecificationToImage" (dict "rootContext" $rootContext "imageSpec" $containerObject.image) -}}
{{- end -}}
