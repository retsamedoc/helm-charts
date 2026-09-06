{{/*
This template serves as a blueprint for Deployment objects that are created
using the common library.
*/}}
{{- define "retsamedoc.common.class.deployment" -}}
  {{- $rootContext := .rootContext -}}
  {{- $deploymentObject := .object -}}

  {{- $labels := merge
    (dict "app.kubernetes.io/controller" $deploymentObject.identifier)
    ($deploymentObject.labels | default dict)
    (include "retsamedoc.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($deploymentObject.annotations | default dict)
    (include "retsamedoc.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $deploymentObject.name }}
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
  revisionHistoryLimit: {{ include "retsamedoc.common.lib.defaultKeepNonNullValue" (dict "value" $deploymentObject.revisionHistoryLimit "default" 3) }}
  {{- if hasKey $deploymentObject "replicas" }}
    {{- if not (eq $deploymentObject.replicas nil) }}
  replicas: {{ $deploymentObject.replicas }}
    {{- end }}
  {{- else }}
  replicas: 1
  {{- end }}
  strategy:
    type: {{ $deploymentObject.strategy }}
    {{- with $deploymentObject.rollingUpdate }}
      {{- if and (eq $deploymentObject.strategy "RollingUpdate") (or (hasKey . "maxUnavailable") (hasKey . "maxSurge")) }}
    rollingUpdate:
        {{- with .maxUnavailable }}
      maxUnavailable: {{ . }}
        {{- end }}
        {{- with .maxSurge }}
      maxSurge: {{ . }}
        {{- end }}
      {{- end }}
    {{- end }}
  selector:
    matchLabels:
      app.kubernetes.io/controller: {{ $deploymentObject.identifier }}
      {{- include "retsamedoc.common.lib.metadata.selectorLabels" $rootContext | nindent 6 }}
  template:
    metadata:
      {{- with (include "retsamedoc.common.lib.pod.metadata.annotations" (dict "rootContext" $rootContext "controllerObject" $deploymentObject)) }}
      annotations: {{ . | nindent 8 }}
      {{- end -}}
      {{- with (include "retsamedoc.common.lib.pod.metadata.labels" (dict "rootContext" $rootContext "controllerObject" $deploymentObject)) }}
      labels: {{ . | nindent 8 }}
      {{- end }}
    spec: {{ include "retsamedoc.common.lib.pod.spec" (dict "rootContext" $rootContext "controllerObject" $deploymentObject) | nindent 6 }}
{{- end -}}
