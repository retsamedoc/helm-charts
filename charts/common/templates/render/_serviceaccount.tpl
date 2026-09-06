{{/*
Renders the serviceAccount object required by the chart.
*/}}
{{- define "retsamedoc.common.render.serviceAccount" -}}
  {{- $rootContext := $ -}}

  {{- $enabledServiceAccounts := (include "retsamedoc.common.lib.serviceAccount.enabledServiceAccounts" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledServiceAccounts -}}
    {{- $serviceAccountObject := (include "retsamedoc.common.lib.serviceAccount.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- include "retsamedoc.common.lib.serviceAccount.validate" (dict "rootContext" $rootContext "object" $serviceAccountObject) -}}

    {{- /* staticToken registers a companion Secret so the SA gets a long-lived token */ -}}
    {{- if $serviceAccountObject.staticToken -}}
      {{- $_ := set $rootContext.Values.secrets (printf "%s-sa-token" $serviceAccountObject.identifier) (dict "suffix" (printf "%s-sa-token" $serviceAccountObject.identifier) "annotations" (dict "kubernetes.io/service-account.name" $serviceAccountObject.name) "type" "kubernetes.io/service-account-token") -}}
    {{- end -}}

    {{- include "retsamedoc.common.class.serviceAccount" (dict "rootContext" $rootContext "object" $serviceAccountObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
