{{/*
Renders the BackendTLSPolicy objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.backendTLSPolicies" -}}
  {{- $rootContext := $ -}}

  {{- $enabled := (include "retsamedoc.common.lib.backendTLSPolicy.enabledBackendTLSPolicies" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabled -}}
    {{- $object := (include "retsamedoc.common.lib.backendTLSPolicy.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}
    {{- include "retsamedoc.common.lib.backendTLSPolicy.validate" (dict "rootContext" $rootContext "object" $object) -}}
    {{- include "retsamedoc.common.class.backendTLSPolicy" (dict "rootContext" $rootContext "object" $object) | nindent 0 -}}
  {{- end -}}
{{- end -}}
