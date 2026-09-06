{{/*
Return a Role Object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.rbac.role.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledRoles := (include "retsamedoc.common.lib.rbac.role.enabledRoles" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledRoles $identifier) -}}
    {{- $objectValues := get $enabledRoles $identifier -}}
    {{- include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledRoles)) -}}
  {{- end -}}
{{- end -}}
