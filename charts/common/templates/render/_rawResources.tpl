{{/*
Renders other arbirtrary objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.rawResources" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate raw resources as required */ -}}
  {{- $enabledRawResources := (include "retsamedoc.common.lib.rawResource.enabledRawResources" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledRawResources -}}
    {{- /* Generate object from the raw resource values */ -}}
    {{- $rawResourceObject := (include "retsamedoc.common.lib.rawResource.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Include the raw resource class */ -}}
    {{- include "retsamedoc.common.class.rawResource" (dict "rootContext" $rootContext "object" $rawResourceObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
