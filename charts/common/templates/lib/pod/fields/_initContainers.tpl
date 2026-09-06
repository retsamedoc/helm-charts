{{- /*
Returns the value for initContainers
*/ -}}
{{- define "retsamedoc.common.lib.pod.field.initContainers" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $controllerObject := .ctx.controllerObject -}}

  {{- $graph := dict -}}
  {{- $containers := list -}}

  {{- $renderedContainers := dict -}}

  {{- range $key, $containerValues := $controllerObject.initContainers -}}
    {{- $containerEnabled := true -}}
    {{- if hasKey $containerValues "enabled" -}}
      {{- $containerEnabled = $containerValues.enabled -}}
    {{- end -}}

    {{- if $containerEnabled -}}
      {{- $containerObject := (include "retsamedoc.common.lib.container.valuesToObject" (dict "rootContext" $rootContext "controllerObject" $controllerObject "containerType" "init" "id" $key "values" $containerValues)) | fromYaml -}}

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
  {{- end -}}

  {{- /* Topological sort so dependsOn containers start in order */ -}}
  {{- $args := dict "graph" $graph "out" list "contextType" "initContainer" "contextId" $controllerObject.identifier -}}
  {{- include "retsamedoc.common.lib.kahn" $args -}}

  {{- range $name := $args.out -}}
    {{- $containerItem := get $renderedContainers $name -}}
    {{- $containers = append $containers $containerItem -}}
  {{- end -}}

  {{- if not (empty $containers) -}}
    {{- $containers | toYaml -}}
  {{- end -}}
{{- end -}}
