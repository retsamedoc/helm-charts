{{/*
This template serves as the blueprint for the StatefulSet objects that are created
within the common library.
*/}}
{{- define "retsamedoc.common.class.statefulset" -}}
  {{- $rootContext := .rootContext -}}
  {{- $statefulsetObject := .object -}}

  {{- $labels := merge
    (dict "app.kubernetes.io/controller" $statefulsetObject.identifier)
    ($statefulsetObject.labels | default dict)
    (include "retsamedoc.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($statefulsetObject.annotations | default dict)
    (include "retsamedoc.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ $statefulsetObject.name }}
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
  revisionHistoryLimit: {{ include "retsamedoc.common.lib.defaultKeepNonNullValue" (dict "value" $statefulsetObject.revisionHistoryLimit "default" 3) }}
  replicas: {{ $statefulsetObject.replicas }}
  podManagementPolicy: {{ dig "statefulset" "podManagementPolicy" "OrderedReady" $statefulsetObject }}
  updateStrategy:
    type: {{ $statefulsetObject.strategy }}
    {{- with $statefulsetObject.rollingUpdate }}
      {{- if and (eq $statefulsetObject.strategy "RollingUpdate") (or (hasKey . "partition") (hasKey . "maxUnavailable")) }}
    rollingUpdate:
        {{- if hasKey . "partition" }}
      partition: {{ .partition }}
        {{- end }}
        {{- if hasKey . "maxUnavailable" }}
      maxUnavailable: {{ .maxUnavailable }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- with (dig "statefulset" "startOrdinal" nil $statefulsetObject) }}
  ordinals:
    start: {{ . }}
  {{- end }}
  selector:
    matchLabels:
      app.kubernetes.io/controller: {{ $statefulsetObject.identifier }}
      {{- include "retsamedoc.common.lib.metadata.selectorLabels" $rootContext | nindent 6 }}
  {{- $serviceName := include "retsamedoc.common.lib.chart.names.fullname" $rootContext }}
  {{- with (dig "statefulset" "serviceName" nil $statefulsetObject) }}
    {{- if kindIs "map" . }}
      {{- $serviceName = (include "retsamedoc.common.lib.service.getByIdentifier" (dict "rootContext" $rootContext "id" .identifier) | fromYaml ).name }}
    {{- else }}
      {{- $serviceName = tpl . $rootContext }}
    {{- end }}
  {{- end }}
  serviceName: {{ $serviceName }}
  {{- with (dig "statefulset" "persistentVolumeClaimRetentionPolicy" nil $statefulsetObject) }}
  persistentVolumeClaimRetentionPolicy:  {{ . | toYaml | nindent 4 }}
  {{- end }}
  template:
    metadata:
      {{- with (include "retsamedoc.common.lib.pod.metadata.annotations" (dict "rootContext" $rootContext "controllerObject" $statefulsetObject)) }}
      annotations: {{ . | nindent 8 }}
      {{- end -}}
      {{- with (include "retsamedoc.common.lib.pod.metadata.labels" (dict "rootContext" $rootContext "controllerObject" $statefulsetObject)) }}
      labels: {{ . | nindent 8 }}
      {{- end }}
    spec: {{ include "retsamedoc.common.lib.pod.spec" (dict "rootContext" $rootContext "controllerObject" $statefulsetObject) | nindent 6 }}
  {{- with (include "retsamedoc.common.lib.statefulset.volumeclaimtemplates" (dict "rootContext" $rootContext "statefulsetObject" $statefulsetObject)) }}
  volumeClaimTemplates: {{ . | nindent 4 }}
  {{- end }}
{{- end }}
