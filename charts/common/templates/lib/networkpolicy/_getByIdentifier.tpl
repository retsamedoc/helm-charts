{{/*
Return a NetworkPolicy object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.networkpolicy.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledNetworkPolicies := (include "retsamedoc.common.lib.networkpolicy.enabledNetworkPolicies" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledNetworkPolicies $identifier) -}}
    {{- $objectValues := get $enabledNetworkPolicies $identifier -}}
    {{- include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledNetworkPolicies)) -}}
  {{- end -}}
{{- end -}}
