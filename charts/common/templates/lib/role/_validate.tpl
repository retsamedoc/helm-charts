{{/*
Validate Role values
*/}}
{{- define "retsamedoc.common.lib.rbac.role.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $roleValues := .object -}}
  {{- $rules := $roleValues.rules -}}

  {{- if not $rules -}}
    {{- fail (printf "Role '%s': Rules cannot be empty. Define at least one rule under 'rbac.roles.%s.rules'." $roleValues.identifier $roleValues.identifier) -}}
  {{- end -}}
{{- end -}}
