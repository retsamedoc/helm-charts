{{/*
This template serves as a blueprint for BackendTLSPolicy objects.
*/}}
{{- define "retsamedoc.common.class.backendTLSPolicy" -}}
  {{- $rootContext := .rootContext -}}
  {{- $object := .object -}}

  {{- $apiVersion := "" -}}
  {{- /* Prefer stable API versions; fall back when Capabilities are empty (helm template / CI). */ -}}
  {{- if $rootContext.Capabilities.APIVersions.Has "gateway.networking.k8s.io/v1/BackendTLSPolicy" }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1" -}}
  {{- else if $rootContext.Capabilities.APIVersions.Has "gateway.networking.k8s.io/v1alpha3/BackendTLSPolicy" }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1alpha3" -}}
  {{- else if $rootContext.Capabilities.APIVersions.Has "gateway.networking.k8s.io/v1alpha2/BackendTLSPolicy" }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1alpha2" -}}
  {{- else -}}
    {{- $apiVersion = "gateway.networking.k8s.io/v1" -}}
  {{- end -}}

  {{- $labels := merge
    ($object.labels | default dict)
    (include "retsamedoc.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($object.annotations | default dict)
    (include "retsamedoc.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
---
apiVersion: {{ $apiVersion }}
kind: BackendTLSPolicy
metadata:
  name: {{ $object.name }}
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
  targetRefs:
  {{- range $object.targetRefs }}
    {{- $targetName := "" -}}
    {{- if .name -}}
      {{- $targetName = tpl .name $rootContext -}}
    {{- else if .identifier -}}
      {{- $service := (include "retsamedoc.common.lib.service.getByIdentifier" (dict "rootContext" $rootContext "id" .identifier) | fromYaml ) -}}
      {{- if not $service -}}
        {{- fail (printf "No enabled Service found with this identifier. (backendTLSPolicy: '%s', identifier: '%s')" $object.identifier .identifier) -}}
      {{- end -}}
      {{- $targetName = $service.name -}}
    {{- end }}
    - group: {{ .group | default "" | quote }}
      kind: {{ .kind | default "Service" }}
      name: {{ $targetName }}
      {{- with .namespace }}
      namespace: {{ . | quote }}
      {{- end }}
      {{- with .sectionName }}
      sectionName: {{ . | quote }}
      {{- end }}
  {{- end }}
  validation:
    hostname: {{ tpl $object.validation.hostname $rootContext | quote }}
    {{- with $object.validation.wellKnownCACertificates }}
    wellKnownCACertificates: {{ . | quote }}
    {{- end }}
    {{- with $object.validation.caCertificateRefs }}
    caCertificateRefs: {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $object.validation.subjectAltNames }}
    subjectAltNames: {{- toYaml . | nindent 6 }}
    {{- end }}
{{- end }}
