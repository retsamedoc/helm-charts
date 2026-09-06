{{/*
Renders the Service objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.services" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate named Services as required */ -}}
  {{- $enabledServices := (include "retsamedoc.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledServices -}}
    {{- /* Generate object from the raw service values */ -}}
    {{- $serviceObject := (include "retsamedoc.common.lib.service.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Perform validations on the Service before rendering */ -}}
    {{- include "retsamedoc.common.lib.service.validate" (dict "rootContext" $rootContext "object" $serviceObject) -}}

    {{- /* Include the Service class */ -}}
    {{- include "retsamedoc.common.class.service" (dict "rootContext" $rootContext "object" $serviceObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
