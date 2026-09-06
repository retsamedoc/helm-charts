{{/*
Validate BackendTLSPolicy values
*/}}
{{- define "retsamedoc.common.lib.backendTLSPolicy.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $object := .object -}}

  {{- if empty $object.targetRefs -}}
    {{- fail (printf "BackendTLSPolicy '%s': targetRefs are required. Define at least one target under 'backendTLSPolicy.%s.targetRefs'." $object.identifier $object.identifier) -}}
  {{- end -}}

  {{- if empty (dig "validation" "hostname" nil $object) -}}
    {{- fail (printf "BackendTLSPolicy '%s': validation.hostname is required under 'backendTLSPolicy.%s.validation'." $object.identifier $object.identifier) -}}
  {{- end -}}

  {{- range $object.targetRefs -}}
    {{- if and (empty .name) (empty .identifier) -}}
      {{- fail (printf "BackendTLSPolicy '%s': each targetRef requires either 'name' or 'identifier'." $object.identifier) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
