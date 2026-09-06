{{/*
Renders the networkPolicy objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.networkpolicies" -}}
  {{- $rootContext := $ -}}

  {{- $enabledNetworkPolicies := (include "retsamedoc.common.lib.networkpolicy.enabledNetworkPolicies" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledNetworkPolicies -}}
    {{- $networkPolicyObject := (include "retsamedoc.common.lib.networkpolicy.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- include "retsamedoc.common.lib.networkpolicy.validate" (dict "rootContext" $ "object" $networkPolicyObject) -}}

    {{- include "retsamedoc.common.class.networkpolicy" (dict "rootContext" $ "object" $networkPolicyObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
