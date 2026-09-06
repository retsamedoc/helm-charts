{{/*
Return a controller object by its Identifier.
*/}}
{{- define "retsamedoc.common.lib.controller.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledControllers := (include "retsamedoc.common.lib.controller.enabledControllers" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledControllers $identifier) -}}
    {{- $objectValues := get $enabledControllers $identifier -}}

    {{- /* Default the controller type to Deployment */ -}}
    {{- if empty (dig "type" nil $objectValues) -}}
      {{- $_ := set $objectValues "type" "deployment" -}}
    {{- end -}}

    {{- include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledControllers)) -}}
  {{- end -}}
{{- end -}}
