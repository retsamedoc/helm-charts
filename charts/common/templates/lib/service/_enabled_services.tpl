{{/*
Return the enabled services.
*/}}
{{- define "retsamedoc.common.lib.service.enabledServices" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledServices := dict -}}

  {{- range $identifier, $objectValues := $rootContext.Values.service -}}
    {{- if kindIs "map" $objectValues -}}
      {{- $serviceEnabled := true -}}
      {{- if hasKey $objectValues "enabled" -}}
        {{- $serviceEnabled = $objectValues.enabled -}}
      {{- end -}}

      {{- if $serviceEnabled -}}
        {{- $_ := set $enabledServices $identifier $objectValues -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- range $identifier, $objectValues := $enabledServices -}}
    {{- $object := include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledServices)) | fromYaml -}}
    {{- $object = include "retsamedoc.common.lib.service.autoDetectController" (dict "rootContext" $rootContext "object" $object) | fromYaml -}}
    {{- $_ := set $enabledServices $identifier $object -}}
  {{- end -}}

  {{- $enabledServices | toYaml -}}
{{- end -}}
