{{- /*
Returns the value for dnsPolicy
*/ -}}
{{- define "retsamedoc.common.lib.pod.field.dnsPolicy" -}}
  {{- $ctx := .ctx -}}
  {{- $controllerObject := $ctx.controllerObject -}}

  {{- /* Default to "ClusterFirst" */ -}}
  {{- $dnsPolicy := "ClusterFirst" -}}

  {{- /* Get hostNetwork value "" */ -}}
  {{- $hostNetwork:= include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "hostNetwork") -}}
  {{- if (eq $hostNetwork "true") -}}
    {{- $dnsPolicy = "ClusterFirstWithHostNet" -}}
  {{- end -}}

  {{- $override := include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "dnsPolicy") -}}

  {{- if not (empty $override) -}}
    {{- $dnsPolicy = $override -}}
  {{- end -}}

  {{- $dnsPolicy -}}
{{- end -}}
