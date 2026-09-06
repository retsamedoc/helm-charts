{{/*
Return the enabled serviceAccounts.
*/}}
{{- define "retsamedoc.common.lib.serviceAccount.enabledServiceAccounts" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledServiceAccounts := dict -}}

  {{- range $identifier, $serviceAccount := $rootContext.Values.serviceAccount -}}
    {{- if kindIs "map" $serviceAccount -}}
      {{- $serviceAccountEnabled := true -}}
      {{- if hasKey $serviceAccount "enabled" -}}
        {{- $serviceAccountEnabled = $serviceAccount.enabled -}}
      {{- end -}}

      {{- if $serviceAccountEnabled -}}
        {{- $_ := set $enabledServiceAccounts $identifier . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- range $identifier, $objectValues := $enabledServiceAccounts -}}
    {{- $object := include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledServiceAccounts)) | fromYaml -}}
    {{- $_ := set $enabledServiceAccounts $identifier $object -}}
  {{- end -}}

  {{- $enabledServiceAccounts | toYaml -}}
{{- end -}}
