{{/*
Renders other arbirtrary objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.rawResources" -}}
  {{- $rootContext := $ -}}

  {{- $enabledRawResources := (include "retsamedoc.common.lib.rawResource.enabledRawResources" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledRawResources -}}
    {{- $rawResourceObject := (include "retsamedoc.common.lib.rawResource.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- include "retsamedoc.common.class.rawResource" (dict "rootContext" $rootContext "object" $rawResourceObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
