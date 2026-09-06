{{/*
Renders RBAC objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.rbac" -}}
  {{- $rootContext := . -}}
  {{- include "retsamedoc.common.render.rbac.roles" (dict "rootContext" $rootContext) -}}
  {{- include "retsamedoc.common.render.rbac.roleBindings" (dict "rootContext" $rootContext) -}}
{{ end }}

{{/*
Renders RBAC Role objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.rbac.roles" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledRoles := (include "retsamedoc.common.lib.rbac.role.enabledRoles" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledRoles -}}
    {{- /* Generate object from the raw role values */ -}}
    {{- $roleObject := (include "retsamedoc.common.lib.rbac.role.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Perform validations on the role before rendering */ -}}
    {{- include "retsamedoc.common.lib.rbac.role.validate" (dict "rootContext" $rootContext "object" $roleObject) -}}

    {{/* Include the role class */}}
    {{- include "retsamedoc.common.class.rbac.Role" (dict "rootContext" $rootContext "object" $roleObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}

{{/*
Renders RBAC RoleBinding objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.rbac.roleBindings" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledRoleBindings := (include "retsamedoc.common.lib.rbac.roleBinding.enabledRoleBindings" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledRoleBindings -}}
    {{- /* Generate object from the raw role values */ -}}
    {{- $roleBindingObject := (include "retsamedoc.common.lib.rbac.roleBinding.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{/* Include the RoleBinding class */}}
    {{- include "retsamedoc.common.class.rbac.roleBinding" (dict "rootContext" $rootContext "object" $roleBindingObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
