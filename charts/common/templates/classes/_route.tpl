{{/*
This template serves as a blueprint for all Route objects that are created
within the common library.
*/}}
{{- define "retsamedoc.common.class.route" -}}
  {{- $rootContext := .rootContext -}}
  {{- $routeObject := .object -}}

  {{- $routeKind := $routeObject.kind | default "HTTPRoute" -}}
  {{- /* Prefer stable API versions; fall back when Capabilities are empty (helm template / CI). */ -}}
  {{- $apiVersion := "" -}}
  {{- if $rootContext.Capabilities.APIVersions.Has (printf "gateway.networking.k8s.io/v1/%s" $routeKind) }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1" -}}
  {{- else if $rootContext.Capabilities.APIVersions.Has (printf "gateway.networking.k8s.io/v1beta1/%s" $routeKind) }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1beta1" -}}
  {{- else if $rootContext.Capabilities.APIVersions.Has (printf "gateway.networking.k8s.io/v1alpha2/%s" $routeKind) }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1alpha2" -}}
  {{- else if or (eq $routeKind "HTTPRoute") (eq $routeKind "GRPCRoute") -}}
    {{- $apiVersion = "gateway.networking.k8s.io/v1" -}}
  {{- else -}}
    {{- $apiVersion = "gateway.networking.k8s.io/v1alpha2" -}}
  {{- end -}}
  {{- $labels := merge
    ($routeObject.labels | default dict)
    (include "retsamedoc.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($routeObject.annotations | default dict)
    (include "retsamedoc.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
---
apiVersion: {{ $apiVersion }}
kind: {{ $routeKind }}
metadata:
  name: {{ $routeObject.name }}
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
  namespace: {{ $routeObject.namespaceOverride | default $rootContext.Release.Namespace }}
spec:
  parentRefs:
  {{- range $routeObject.parentRefs }}
    - group: {{ .group | default "gateway.networking.k8s.io" }}
      kind: {{ .kind | default "Gateway" }}
      name: {{ required (printf "parentRef name is required for %v %v" $routeKind $routeObject.name) .name }}
      {{- if .namespace }}
      namespace: {{ .namespace | quote }}
      {{- end }}
      {{- if .sectionName }}
      sectionName: {{ .sectionName | quote }}
      {{- end }}
      {{- if .port }}
      port: {{ .port }}
      {{- end }}
  {{- end }}
  {{- if and (ne $routeKind "TCPRoute") (ne $routeKind "UDPRoute") $routeObject.hostnames }}
  hostnames:
    {{- range $routeObject.hostnames }}
    - {{ tpl . $rootContext | quote }}
    {{- end }}
  {{- end }}
  rules:
  {{- range $routeObject.rules }}
    - {{ with .name -}}
        name: {{ tpl . $rootContext }}
      {{ end -}}
      backendRefs:
      {{- if empty .backendRefs }}
         []
      {{ else -}}
        {{- range .backendRefs -}}
          {{- $service := dict -}}
          {{- $serviceName := "" -}}
          {{- $servicePort := 0 -}}
          {{- if .name -}}
            {{- $serviceName = tpl .name $rootContext -}}
          {{- else if .identifier -}}
            {{- $service = (include "retsamedoc.common.lib.service.getByIdentifier" (dict "rootContext" $rootContext "id" .identifier) | fromYaml ) -}}
            {{- if not $service -}}
              {{- fail (printf "No enabled Service found with this identifier. (route: '%s', identifier: '%s')" $routeObject.identifier .identifier) -}}
            {{- end -}}
            {{- $serviceName = $service.name -}}
          {{- end -}}
          {{- if empty .port -}}
            {{- /* Fall back to the Service primary port when the backend omits port */ -}}
            {{- if $service -}}
              {{- $defaultServicePort := include "retsamedoc.common.lib.service.primaryPort" (dict "rootContext" $rootContext "serviceObject" $service) | fromYaml -}}
              {{- if $defaultServicePort -}}
                {{- $servicePort = $defaultServicePort.port -}}
              {{- end -}}
            {{- end -}}
          {{- else -}}
            {{- if kindIs "float64" .port -}}
              {{- $servicePort = .port -}}
            {{- else if kindIs "string" .port -}}
              {{- $servicePort = include "retsamedoc.common.lib.service.getPortNumberByName" (dict "rootContext" $rootContext "serviceID" $service.identifier "portName" .port) -}}
              {{- if not $servicePort -}}
                {{- fail (printf "No enabled Service Port found with this identifier. (route: '%s', service: '%s', identifier: '%s')" $routeObject.identifier $service.identifier .port) -}}
              {{- end -}}
            {{- end -}}
          {{- end }}
        - group: {{ .group | default "" | quote}}
          kind: {{ .kind | default "Service" }}
          name: {{ $serviceName }}
          namespace: {{ .namespace | default $rootContext.Release.Namespace }}
          {{- if $servicePort }}
          port: {{ $servicePort }}
          {{- end }}
          weight: {{ include "retsamedoc.common.lib.defaultKeepNonNullValue" (dict "value" .weight "default" 1) }}
          {{- with .filters }}
          filters: {{- toYaml . | nindent 12 }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- if or (eq $routeKind "HTTPRoute") (eq $routeKind "GRPCRoute") }}
        {{- with .matches }}
      matches: {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- with .filters }}
      filters: {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- with .sessionPersistence }}
      sessionPersistence: {{- toYaml . | nindent 8 }}
        {{- end }}
      {{- end }}
      {{- if (eq $routeKind "HTTPRoute") }}
        {{- with .timeouts }}
      timeouts: {{- toYaml . | nindent 8 }}
        {{- end }}
      {{- end }}
  {{- end }}
{{- end }}
