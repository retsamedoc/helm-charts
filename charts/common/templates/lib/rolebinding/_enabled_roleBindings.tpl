{{/*
Return the enabled RoleBindings.
*/}}
{{- define "retsamedoc.common.lib.rbac.roleBinding.enabledRoleBindings" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledRoleBindings := dict -}}

  {{- range $name, $role := $rootContext.Values.rbac.bindings -}}
    {{- if kindIs "map" $role -}}
      {{- $roleEnabled := true -}}
      {{- if hasKey $role "enabled" -}}
        {{- $roleEnabled = $role.enabled -}}
      {{- end -}}

      {{- if $roleEnabled -}}
        {{- $_ := set $enabledRoleBindings $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledRoleBindings | toYaml -}}
{{- end -}}
