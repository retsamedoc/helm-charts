{{/*
Env field used by the container.
*/}}
{{- define "retsamedoc.common.lib.container.field.env" -}}
  {{- $ctx := .ctx -}}
  {{- $rootContext := $ctx.rootContext -}}
  {{- $containerObject := $ctx.containerObject -}}
  {{- $envValues := get $containerObject "env" -}}

  {{- $envList := list -}}

  {{- if not (empty $envValues) -}}
    {{- if kindIs "slice" $envValues -}}
      {{- /* List form: preserve author order */ -}}
      {{- range $name, $var := $envValues -}}
        {{- if kindIs "int" $name -}}
          {{- $name = required "environment variables as a list of maps require a name field" $var.name -}}
        {{- end -}}
      {{- end -}}
      {{- $envList = $envValues -}}
    {{- else -}}
      {{- /* Map form: optional dependsOn is topologically sorted */ -}}
      {{- $graph := dict -}}

      {{- range $name, $var := $envValues -}}
        {{- if kindIs "map" $var -}}
          {{- if empty (dig "dependsOn" nil $var) -}}
            {{- $_ := set $graph $name ( list ) -}}
          {{- else if kindIs "string" $var.dependsOn -}}
            {{- $_ := set $graph $name ( list $var.dependsOn ) -}}
          {{- else if kindIs "slice" $var.dependsOn -}}
            {{- $_ := set $graph $name $var.dependsOn -}}
          {{- end -}}
        {{- else -}}
          {{- $_ := set $graph $name ( list ) -}}
        {{- end -}}
      {{- end -}}

      {{- $args := dict "graph" $graph "out" list "contextType" "env" "contextId" $containerObject.identifier -}}
      {{- include "retsamedoc.common.lib.kahn" $args -}}

      {{- range $name := $args.out -}}
        {{- $envItem := dict "name" $name -}}
        {{- $envValue := get $envValues $name -}}

        {{- if kindIs "map" $envValue -}}
          {{- $envItem = merge $envItem (omit $envValue "dependsOn") -}}
        {{- else -}}
          {{- $_ := set $envItem "value" $envValue -}}
        {{- end -}}

        {{- $envList = append $envList $envItem -}}
      {{- end -}}

      {{- $args = dict -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $envList) -}}
    {{- $output := list -}}
    {{- range $envList -}}
      {{- if hasKey . "value" -}}
        {{- if kindIs "string" .value -}}
          {{- $output = append $output (dict "name" .name "value" (tpl .value $rootContext)) -}}
        {{- else if or (kindIs "float64" .value) (kindIs "bool" .value) -}}
          {{- $output = append $output (dict "name" .name "value" (.value | toString)) -}}
        {{- else -}}
          {{- $output = append $output (dict "name" .name "value" .value) -}}
        {{- end -}}
      {{- else if hasKey . "valueFrom" -}}
        {{- $parsedValue := (tpl (.valueFrom | toYaml) $rootContext) | fromYaml -}}
        {{- $output = append $output (dict "name" .name "valueFrom" $parsedValue) -}}
      {{- else -}}
        {{- $output = append $output (dict "name" .name "valueFrom" (omit . "name")) -}}
      {{- end -}}
    {{- end -}}
    {{- $output | toYaml -}}
  {{- end -}}
{{- end -}}
