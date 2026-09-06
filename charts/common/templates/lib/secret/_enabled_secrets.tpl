{{/*
Return the enabled secrets.
*/}}
{{- define "retsamedoc.common.lib.secret.enabledSecrets" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledSecrets := dict -}}

  {{- range $identifier, $secret := $rootContext.Values.secrets -}}
    {{- if kindIs "map" $secret -}}
      {{- $secretEnabled := true -}}
      {{- if hasKey $secret "enabled" -}}
        {{- $secretEnabled = $secret.enabled -}}
      {{- end -}}

      {{- if $secretEnabled -}}
        {{- $_ := set $enabledSecrets $identifier . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledSecrets | toYaml -}}
{{- end -}}
