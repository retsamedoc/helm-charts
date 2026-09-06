{{/*
This template serves as the blueprint for the DaemonSet objects that are created
within the common library.
*/}}
{{- define "retsamedoc.common.class.daemonset" -}}
  {{- $rootContext := .rootContext -}}
  {{- $daemonsetObject := .object -}}

  {{- $labels := merge
    (dict "app.kubernetes.io/controller" $daemonsetObject.identifier)
    ($daemonsetObject.labels | default dict)
    (include "retsamedoc.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($daemonsetObject.annotations | default dict)
    (include "retsamedoc.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: {{ $daemonsetObject.name }}
  {{- with $labels }}
  labels:
    {{- range $key, $value := . }}
      {{- printf "%s: %s" $key (tpl $value $rootContext | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with $annotations }}
  annotations:
    {{- range $key, $value := . }}
      {{- printf "%s: %s" $key (tpl $value $rootContext | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  namespace: {{ $rootContext.Release.Namespace }}
spec:
  revisionHistoryLimit: {{ include "retsamedoc.common.lib.defaultKeepNonNullValue" (dict "value" $daemonsetObject.revisionHistoryLimit "default" 3) }}
  {{- if $daemonsetObject.strategy }}
  updateStrategy:
    type: {{ $daemonsetObject.strategy }}
    {{- with $daemonsetObject.rollingUpdate }}
      {{- if and (eq $daemonsetObject.strategy "RollingUpdate") (or (hasKey . "maxUnavailable") (hasKey . "maxSurge")) }}
    rollingUpdate:
        {{- with .maxUnavailable }}
      maxUnavailable: {{ . }}
        {{- end }}
        {{- with .maxSurge }}
      maxSurge: {{ . }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
  selector:
    matchLabels:
      app.kubernetes.io/controller: {{ $daemonsetObject.identifier }}
      {{- include "retsamedoc.common.lib.metadata.selectorLabels" $rootContext | nindent 6 }}
  template:
    metadata:
      annotations: {{ include "retsamedoc.common.lib.pod.metadata.annotations" (dict "rootContext" $rootContext "controllerObject" $daemonsetObject) | nindent 8 }}
      labels: {{ include "retsamedoc.common.lib.pod.metadata.labels" (dict "rootContext" $rootContext "controllerObject" $daemonsetObject) | nindent 8 }}
    spec: {{ include "retsamedoc.common.lib.pod.spec" (dict "rootContext" $rootContext "controllerObject" $daemonsetObject) | nindent 6 }}
{{- end }}
