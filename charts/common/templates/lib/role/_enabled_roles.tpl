{{/*
Return the enabled roles.
*/}}
{{- define "retsamedoc.common.lib.rbac.role.enabledRoles" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledRoles := dict -}}

  {{- range $name, $role := $rootContext.Values.rbac.roles -}}
    {{- if kindIs "map" $role -}}
      {{- $roleEnabled := true -}}
      {{- if hasKey $role "enabled" -}}
        {{- $roleEnabled = $role.enabled -}}
      {{- end -}}

      {{- if $roleEnabled -}}
        {{- $_ := set $enabledRoles $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledRoles | toYaml -}}
{{- end -}}
