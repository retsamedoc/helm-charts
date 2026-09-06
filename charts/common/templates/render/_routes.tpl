{{/*
Renders the Route objects required by the chart
*/}}
{{- define "retsamedoc.common.render.routes" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate named routes as required */ -}}
  {{- $enabledRoutes := (include "retsamedoc.common.lib.route.enabledRoutes" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledRoutes -}}
    {{- /* Generate object from the raw route values */ -}}
    {{- $routeObject := (include "retsamedoc.common.lib.route.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Perform validations on the Route before rendering */ -}}
    {{- include "retsamedoc.common.lib.route.validate" (dict "rootContext" $rootContext "object" $routeObject) -}}

    {{- /* Include the Route class */ -}}
    {{- include "retsamedoc.common.class.route" (dict "rootContext" $rootContext "object" $routeObject) | nindent 0 -}}

    {{- /* Include the ReferenceGrant class (renders empty when not needed) */ -}}
    {{- include "retsamedoc.common.class.route.referenceGrant" (dict "rootContext" $rootContext "object" $routeObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
