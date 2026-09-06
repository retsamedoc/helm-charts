{{- /*
Returns the value for containers
*/ -}}
{{- define "retsamedoc.common.lib.pod.field.containers" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $controllerObject := .ctx.controllerObject -}}

  {{- $graph := dict -}}
  {{- $containers := list -}}

  {{- $enabledContainers := include "retsamedoc.common.lib.controller.enabledContainers" (dict "rootContext" $rootContext "controllerObject" $controllerObject) | fromYaml }}
  {{- $renderedContainers := dict -}}

  {{- range $key, $containerValues := $enabledContainers -}}
    {{- $containerObject := (include "retsamedoc.common.lib.container.valuesToObject" (dict "rootContext" $rootContext "controllerObject" $controllerObject "containerType" "default" "id" $key "values" $containerValues)) | fromYaml -}}

    {{- include "retsamedoc.common.lib.container.validate" (dict "rootContext" $rootContext "controllerObject" $controllerObject "containerObject" $containerObject) -}}

    {{- $renderedContainer := include "retsamedoc.common.lib.container.spec" (dict "rootContext" $rootContext "controllerObject" $controllerObject "containerObject" $containerObject) | fromYaml -}}
    {{- $_ := set $renderedContainers $key $renderedContainer -}}

    {{- /* dependsOn edges feed Kahn ordering below */ -}}
    {{- if empty (dig "dependsOn" nil $containerValues) -}}
      {{- $_ := set $graph $key ( list ) -}}
    {{- else if kindIs "string" $containerValues.dependsOn -}}
      {{- $_ := set $graph $key ( list $containerValues.dependsOn ) -}}
    {{- else if kindIs "slice" $containerValues.dependsOn -}}
      {{- $_ := set $graph $key $containerValues.dependsOn -}}
    {{- end -}}

  {{- end -}}

  {{- /* Topological sort so dependsOn containers start in order */ -}}
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
