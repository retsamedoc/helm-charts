{{/*
Convert values to an object
*/}}
{{- define "retsamedoc.common.lib.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}
  {{- $itemCount := .itemCount -}}

  {{- $objectName := (include "retsamedoc.common.lib.determineResourceNameFromValues" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" $itemCount)) -}}

  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- $objectValues | toYaml -}}
{{- end -}}
