{{/* Common labels shared across objects */}}
{{- define "retsamedoc.common.lib.metadata.allLabels" -}}
helm.sh/chart: {{ include "retsamedoc.common.lib.chart.names.chart" . }}
{{ include "retsamedoc.common.lib.metadata.selectorLabels" . }}
  {{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
  {{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "retsamedoc.common.lib.metadata.globalLabels" . }}
{{- end -}}
