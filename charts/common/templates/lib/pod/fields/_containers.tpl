{{- /*
Returns the value for containers
*/ -}}
{{- define "retsamedoc.common.lib.pod.field.containers" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $controllerObject := .ctx.controllerObject -}}

  {{- /* Default to empty list */ -}}
  {{- $graph := dict -}}
  {{- $containers := list -}}

  {{- /* Fetch configured containers for this controller */ -}}
  {{- $enabledContainers := include "retsamedoc.common.lib.controller.enabledContainers" (dict "rootContext" $rootContext "controllerObject" $controllerObject) | fromYaml }}
  {{- $renderedContainers := dict -}}

  {{- range $key, $containerValues := $enabledContainers -}}
    {{- /* Create object from the container values */ -}}
    {{- $containerObject := (include "retsamedoc.common.lib.container.valuesToObject" (dict "rootContext" $rootContext "controllerObject" $controllerObject "containerType" "default" "id" $key "values" $containerValues)) | fromYaml -}}

    {{- /* Perform validations on the Container before rendering */ -}}
    {{- include "retsamedoc.common.lib.container.validate" (dict "rootContext" $rootContext "controllerObject" $controllerObject "containerObject" $containerObject) -}}

    {{- /* Generate the Container spec */ -}}
    {{- $renderedContainer := include "retsamedoc.common.lib.container.spec" (dict "rootContext" $rootContext "controllerObject" $controllerObject "containerObject" $containerObject) | fromYaml -}}
    {{- $_ := set $renderedContainers $key $renderedContainer -}}

    {{- /* Determine the Container order */ -}}
    {{- if empty (dig "dependsOn" nil $containerValues) -}}
      {{- $_ := set $graph $key ( list ) -}}
    {{- else if kindIs "string" $containerValues.dependsOn -}}
      {{- $_ := set $graph $key ( list $containerValues.dependsOn ) -}}
    {{- else if kindIs "slice" $containerValues.dependsOn -}}
      {{- $_ := set $graph $key $containerValues.dependsOn -}}
    {{- end -}}

  {{- end -}}

  {{- /* Process graph */ -}}
  {{- $args := dict "graph" $graph "out" list "contextType" "container" "contextId" $controllerObject.identifier -}}
  {{- include "retsamedoc.common.lib.kahn" $args -}}

  {{- range $name := $args.out -}}
    {{- $containerItem := get $renderedContainers $name -}}
    {{- $containers = append $containers $containerItem -}}
  {{- end -}}

  {{- if not (empty $containers) -}}
    {{- $containers | toYaml -}}
  {{- end -}}
{{- end -}}
