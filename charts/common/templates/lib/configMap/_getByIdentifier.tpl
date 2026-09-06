{{/*
Return a configMap Object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.configMap.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledConfigMaps := (include "retsamedoc.common.lib.configMap.enabledConfigmaps" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledConfigMaps $identifier) -}}
    {{- $objectValues := get $enabledConfigMaps $identifier -}}
    {{- include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledConfigMaps)) -}}
  {{- end -}}
{{- end -}}
