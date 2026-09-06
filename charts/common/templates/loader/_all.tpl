{{/*
Main entrypoint for the common library chart. It will render all underlying templates based on the provided values.
*/}}
{{- define "retsamedoc.common.loader.all" -}}
  {{- /* Generate chart and dependency values */ -}}
  {{- include "retsamedoc.common.loader.init" . -}}

  {{- /* Generate remaining objects */ -}}
  {{- include "retsamedoc.common.loader.generate" . -}}
{{- end -}}
