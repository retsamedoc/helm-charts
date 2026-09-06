{{- define "retsamedoc.common.loader.init" -}}
  {{- /* Merge the local chart values and the common chart defaults */ -}}
  {{- include "retsamedoc.common.values.init" . }}
{{- end -}}
