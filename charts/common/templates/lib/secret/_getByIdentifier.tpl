{{/*
Return a secret Object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.secret.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledSecrets := (include "retsamedoc.common.lib.secret.enabledSecrets" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledSecrets $identifier) -}}
    {{- $objectValues := get $enabledSecrets $identifier -}}
    {{- include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledSecrets)) -}}
  {{- end -}}
{{- end -}}
