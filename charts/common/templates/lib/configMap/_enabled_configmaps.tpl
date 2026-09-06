{{/*
Return the enabled configMaps.
*/}}
{{- define "retsamedoc.common.lib.configMap.enabledConfigmaps" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledSecrets := dict -}}

  {{- range $identifier, $secret := $rootContext.Values.configMaps -}}
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
