{{/*
Renders the Ingress objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.ingresses" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate Ingresses as required */ -}}
  {{- $enabledIngresses := (include "retsamedoc.common.lib.ingress.enabledIngresses" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledIngresses -}}
    {{- /* Generate object from the raw persistence values */ -}}
    {{- $ingressObject := (include "retsamedoc.common.lib.ingress.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Perform validations on the Ingress before rendering */ -}}
    {{- include "retsamedoc.common.lib.ingress.validate" (dict "rootContext" $rootContext "object" $ingressObject) -}}

    {{- /* Include the ingress class */ -}}
    {{- include "retsamedoc.common.class.ingress" (dict "rootContext" $ "object" $ingressObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
