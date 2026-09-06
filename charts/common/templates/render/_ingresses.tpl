{{/*
Renders the Ingress objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.ingresses" -}}
  {{- $rootContext := $ -}}

  {{- $enabledIngresses := (include "retsamedoc.common.lib.ingress.enabledIngresses" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledIngresses -}}
    {{- $ingressObject := (include "retsamedoc.common.lib.ingress.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- include "retsamedoc.common.lib.ingress.validate" (dict "rootContext" $rootContext "object" $ingressObject) -}}

    {{- include "retsamedoc.common.class.ingress" (dict "rootContext" $ "object" $ingressObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
