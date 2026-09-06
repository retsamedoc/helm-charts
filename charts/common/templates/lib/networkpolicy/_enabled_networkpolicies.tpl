{{/*
Return the enabled NetworkPolicies.
*/}}
{{- define "retsamedoc.common.lib.networkpolicy.enabledNetworkPolicies" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledNetworkPolicies := dict -}}

  {{- range $name, $networkPolicy := $rootContext.Values.networkPolicy -}}
    {{- if kindIs "map" $networkPolicy -}}
      {{- $networkPolicyEnabled := true -}}
      {{- if hasKey $networkPolicy "enabled" -}}
        {{- $networkPolicyEnabled = $networkPolicy.enabled -}}
      {{- end -}}

      {{- if $networkPolicyEnabled -}}
        {{- $_ := set $enabledNetworkPolicies $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledNetworkPolicies | toYaml -}}
{{- end -}}
