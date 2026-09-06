{{/*
Renders the Route objects required by the chart
*/}}
{{- define "retsamedoc.common.render.routes" -}}
  {{- $rootContext := $ -}}

  {{- $enabledRoutes := (include "retsamedoc.common.lib.route.enabledRoutes" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledRoutes -}}
    {{- $routeObject := (include "retsamedoc.common.lib.route.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- include "retsamedoc.common.lib.route.validate" (dict "rootContext" $rootContext "object" $routeObject) -}}

    {{- include "retsamedoc.common.class.route" (dict "rootContext" $rootContext "object" $routeObject) | nindent 0 -}}

    {{- /* May emit a ReferenceGrant for cross-namespace backends; often empty */ -}}
    {{- include "retsamedoc.common.class.route.referenceGrant" (dict "rootContext" $rootContext "object" $routeObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
