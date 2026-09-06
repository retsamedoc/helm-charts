{{/*
Return the enabled BackendTLSPolicy objects.
*/}}
{{- define "retsamedoc.common.lib.backendTLSPolicy.enabledBackendTLSPolicies" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabled := dict -}}

  {{- range $identifier, $policy := $rootContext.Values.backendTLSPolicy -}}
    {{- if kindIs "map" $policy -}}
      {{- $enabledFlag := true -}}
      {{- if hasKey $policy "enabled" -}}
        {{- $enabledFlag = $policy.enabled -}}
      {{- end -}}

      {{- if $enabledFlag -}}
        {{- $_ := set $enabled $identifier . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- range $identifier, $objectValues := $enabled -}}
    {{- $object := include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabled)) | fromYaml -}}
    {{- $_ := set $enabled $identifier $object -}}
  {{- end -}}

  {{- $enabled | toYaml -}}
{{- end -}}
