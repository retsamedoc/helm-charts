{{/* Selector labels shared across objects */}}
{{- define "retsamedoc.common.lib.metadata.selectorLabels" -}}
app.kubernetes.io/name: {{ include "retsamedoc.common.lib.chart.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
