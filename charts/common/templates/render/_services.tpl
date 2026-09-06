{{/*
Renders the Service objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.services" -}}
  {{- $rootContext := $ -}}

  {{- $enabledServices := (include "retsamedoc.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledServices -}}
    {{- $serviceObject := (include "retsamedoc.common.lib.service.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- include "retsamedoc.common.lib.service.validate" (dict "rootContext" $rootContext "object" $serviceObject) -}}

    {{- include "retsamedoc.common.class.service" (dict "rootContext" $rootContext "object" $serviceObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
