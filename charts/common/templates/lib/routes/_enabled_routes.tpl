{{/*
Return the enabled routes.
*/}}
{{- define "retsamedoc.common.lib.route.enabledRoutes" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledRoutes := dict -}}

  {{- range $name, $route := $rootContext.Values.route -}}
    {{- if kindIs "map" $route -}}
      {{- $routeEnabled := true -}}
      {{- if hasKey $route "enabled" -}}
        {{- $routeEnabled = $route.enabled -}}
      {{- end -}}

      {{- if $routeEnabled -}}
        {{- $_ := set $enabledRoutes $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- range $identifier, $objectValues := $enabledRoutes -}}
    {{- $object := include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledRoutes)) | fromYaml -}}
    {{- $object = include "retsamedoc.common.lib.route.autoDetectService" (dict "rootContext" $rootContext "object" $object) | fromYaml -}}
    {{- $_ := set $enabledRoutes $identifier $object -}}
  {{- end -}}

  {{- $enabledRoutes | toYaml -}}
{{- end -}}
