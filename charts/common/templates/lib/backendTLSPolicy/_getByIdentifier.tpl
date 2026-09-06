{{/*
Return a BackendTLSPolicy Object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.backendTLSPolicy.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabled := (include "retsamedoc.common.lib.backendTLSPolicy.enabledBackendTLSPolicies" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabled $identifier) -}}
    {{- $objectValues := get $enabled $identifier -}}
    {{- include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabled)) -}}
  {{- end -}}
{{- end -}}
