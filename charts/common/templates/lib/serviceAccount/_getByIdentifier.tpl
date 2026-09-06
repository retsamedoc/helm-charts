{{/*
Return a ServiceAccount Object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.serviceAccount.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledServiceAccounts := (include "retsamedoc.common.lib.serviceAccount.enabledServiceAccounts" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledServiceAccounts $identifier) -}}
    {{- get $enabledServiceAccounts $identifier | toYaml -}}
  {{- end -}}
{{- end -}}
