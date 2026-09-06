{{/*
Validate PodDisruptionBudget values
*/}}
{{- define "retsamedoc.common.lib.podDisruptionBudget.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $podDisruptionBudgetObject := .object -}}

  {{- if empty (get $podDisruptionBudgetObject "controller") -}}
    {{- fail (printf "PodDisruptionBudget '%s': Controller reference is required. Specify a controller under 'controllers.%s.podDisruptionBudget' (or ensure the controller identifier is set)." $podDisruptionBudgetObject.identifier $podDisruptionBudgetObject.identifier) -}}
  {{- end -}}
{{- end -}}
