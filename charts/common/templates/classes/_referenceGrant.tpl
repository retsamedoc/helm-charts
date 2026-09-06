{{/*
This template renders a ReferenceGrant object that authorizes a Route in a different namespace to reference Services in the release namespace.
It returns empty output when no cross-namespace reference is detected.
*/}}
{{- define "retsamedoc.common.class.route.referenceGrant" -}}
  {{- $rootContext := .rootContext -}}
  {{- $routeObject := .object -}}

  {{- $routeKind := $routeObject.kind | default "HTTPRoute" -}}
  {{- $routeNamespace := $routeObject.namespaceOverride | default $rootContext.Release.Namespace -}}
  {{- /* Prefer stable API versions; fall back when Capabilities are empty (helm template / CI). */ -}}
  {{- $apiVersion := "" -}}
  {{- if $rootContext.Capabilities.APIVersions.Has "gateway.networking.k8s.io/v1/ReferenceGrant" }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1" -}}
  {{- else if $rootContext.Capabilities.APIVersions.Has "gateway.networking.k8s.io/v1beta1/ReferenceGrant" }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1beta1" -}}
  {{- else if $rootContext.Capabilities.APIVersions.Has "gateway.networking.k8s.io/v1alpha2/ReferenceGrant" }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1alpha2" -}}
  {{- else -}}
    {{- $apiVersion = "gateway.networking.k8s.io/v1beta1" -}}
  {{- end -}}

  {{- if ne $routeNamespace $rootContext.Release.Namespace -}}
    {{- $grantEnabled := true -}}
    {{- if hasKey $routeObject "referenceGrant" -}}
      {{- if hasKey $routeObject.referenceGrant "enabled" -}}
        {{- $grantEnabled = $routeObject.referenceGrant.enabled -}}
      {{- end -}}
    {{- end -}}

    {{- if $grantEnabled -}}
      {{- $serviceNames := list -}}
      {{- range $routeObject.rules -}}
        {{- range .backendRefs -}}
          {{- $backendRef := . -}}
          {{- $serviceName := "" -}}
          {{- $serviceNamespace := "" -}}
          {{- if .name -}}
            {{- $serviceName = tpl .name $rootContext -}}
            {{- $serviceNamespace = .namespace | default $rootContext.Release.Namespace -}}
          {{- else if .identifier -}}
            {{- $service := (include "retsamedoc.common.lib.service.getByIdentifier" (dict "rootContext" $rootContext "id" .identifier) | fromYaml ) -}}
            {{- if $service -}}
              {{- $serviceName = $service.name -}}
              {{- $serviceNamespace = $rootContext.Release.Namespace -}}
            {{- end -}}
          {{- end -}}
          {{- if and $serviceName (eq $serviceNamespace $rootContext.Release.Namespace) -}}
            {{- if not (has $serviceName $serviceNames) -}}
              {{- $serviceNames = append $serviceNames $serviceName -}}
            {{- end -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}

      {{- if $serviceNames -}}
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
kind: ReferenceGrant
metadata:
  name: {{ $routeObject.name }}
  namespace: {{ $rootContext.Release.Namespace }}
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
spec:
  from:
    - group: gateway.networking.k8s.io
      kind: {{ $routeKind }}
      namespace: {{ $routeNamespace }}
  to:
    {{- range $serviceName := $serviceNames }}
    - group: ""
      kind: Service
      name: {{ $serviceName }}
    {{- end }}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
