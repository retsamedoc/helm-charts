{{/*
Probes used by the container.
*/}}
{{- define "retsamedoc.common.lib.container.field.probes" -}}
  {{- $ctx := .ctx -}}
  {{- $rootContext := $ctx.rootContext -}}
  {{- $controllerObject := $ctx.controllerObject -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- $enabledProbes := dict -}}

  {{- range $probeName, $probeValues := $containerObject.probes -}}
    {{- $probeEnabled := false -}}
    {{- if hasKey $probeValues "enabled" -}}
      {{- $probeEnabled = $probeValues.enabled -}}
    {{- end -}}

    {{- if $probeEnabled -}}
      {{- $probeDefinition := dict -}}

      {{- if $probeValues.custom -}}
        {{- $parsedProbeSpec := tpl ($probeValues.spec | toYaml) $rootContext -}}
        {{- $probeDefinition = $parsedProbeSpec | fromYaml -}}
      {{- else -}}
        {{- $probeSpec := dig "spec" dict $probeValues -}}

        {{- $primaryService := include "retsamedoc.common.lib.service.primaryForController" (dict "rootContext" $rootContext "controllerIdentifier" $controllerObject.identifier) | fromYaml -}}
        {{- $primaryServiceDefaultPort := dict -}}
        {{- if $primaryService -}}
          {{- $primaryServiceDefaultPort = include "retsamedoc.common.lib.service.primaryPort" (dict "rootContext" $rootContext "serviceObject" $primaryService) | fromYaml -}}
        {{- end -}}

        {{- $_ := set $probeDefinition "initialDelaySeconds" (include "retsamedoc.common.lib.defaultKeepNonNullValue" (dict "value" $probeSpec.initialDelaySeconds "default" 0) | int) -}}
        {{- $_ := set $probeDefinition "failureThreshold" (include "retsamedoc.common.lib.defaultKeepNonNullValue" (dict "value" $probeSpec.failureThreshold "default" 3) | int) -}}
        {{- $_ := set $probeDefinition "timeoutSeconds" (include "retsamedoc.common.lib.defaultKeepNonNullValue" (dict "value" $probeSpec.timeoutSeconds "default" 1) | int) -}}
        {{- $_ := set $probeDefinition "periodSeconds" (include "retsamedoc.common.lib.defaultKeepNonNullValue" (dict "value" $probeSpec.periodSeconds "default" 10) | int) -}}

        {{- $probeType := "" -}}
        {{- $probeHeader := "" -}}

        {{- /* AUTO inherits protocol from the controller's primary Service port */ -}}
        {{- if eq $probeValues.type "AUTO" -}}
          {{- $probeType = $primaryServiceDefaultPort.protocol -}}
        {{- else -}}
          {{- $probeType = $probeValues.type | default "TCP" -}}
        {{- end -}}

        {{- if or ( eq $probeType "HTTPS" ) ( eq $probeType "HTTP" ) -}}
          {{- $probeHeader = "httpGet" -}}
          {{- $_ := set $probeDefinition $probeHeader (
            dict
              "path" $probeValues.path
              "scheme" $probeType
            )
          -}}

        {{- else if (eq $probeType "GRPC") -}}
          {{- $probeHeader = "grpc" -}}
          {{- $_ := set $probeDefinition $probeHeader dict -}}
            {{- if $probeValues.service -}}
              {{- $_ := set (index $probeDefinition $probeHeader) "service" $probeValues.service -}}
            {{- end -}}

        {{- else -}}
          {{- /* Non-HTTP/GRPC types (including default TCP) use tcpSocket */ -}}
          {{- $probeHeader = "tcpSocket" -}}
          {{- $_ := set $probeDefinition $probeHeader dict -}}
        {{- end -}}

        {{- if $probeValues.port -}}
          {{- if kindIs "float64" $probeValues.port -}}
            {{- $_ := set (index $probeDefinition $probeHeader) "port" $probeValues.port -}}
          {{- else if kindIs "string" $probeValues.port -}}
            {{- $_ := set (index $probeDefinition $probeHeader) "port" (tpl ( $probeValues.port | toString ) $rootContext) -}}
          {{- end -}}
        {{- else if $primaryServiceDefaultPort.targetPort -}}
          {{- $_ := set (index $probeDefinition $probeHeader) "port" $primaryServiceDefaultPort.targetPort -}}
        {{- else if $primaryServiceDefaultPort.port -}}
          {{- $_ := set (index $probeDefinition $probeHeader) "port" ($primaryServiceDefaultPort.port | toString | atoi ) -}}
        {{- end -}}
      {{- end -}}

      {{- if $probeDefinition -}}
        {{- $_ := set $enabledProbes (printf "%sProbe" $probeName) $probeDefinition -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- with $enabledProbes -}}
    {{- . | toYaml -}}
  {{- end -}}
{{- end -}}
