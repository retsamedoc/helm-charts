{{/*
Renders the controller objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.controllers" -}}
  {{- $rootContext := $ -}}

  {{- $enabledControllers := (include "retsamedoc.common.lib.controller.enabledControllers" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledControllers -}}
    {{- $controllerObject := (include "retsamedoc.common.lib.controller.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- include "retsamedoc.common.lib.controller.validate" (dict "rootContext" $rootContext "object" $controllerObject) -}}

    {{- /* HPA owns replica count: seed minReplicas from values.replicas, then clear replicas on the controller */ -}}
    {{- if $controllerObject.horizontalPodAutoscaler -}}
      {{- $controllerValues := get $rootContext.Values.controllers $identifier -}}
      {{- if and (hasKey $controllerValues "replicas") (ne (get $controllerValues "replicas") nil) -}}
        {{- if not (hasKey $controllerObject.horizontalPodAutoscaler "minReplicas") -}}
          {{- $_ := set $controllerObject.horizontalPodAutoscaler "minReplicas" (get $controllerValues "replicas") -}}
        {{- end -}}
      {{- end -}}
      {{- $_ := set $controllerObject "replicas" nil -}}
    {{- end -}}

    {{- if eq $controllerObject.type "deployment" -}}
      {{- $deploymentObject := (include "retsamedoc.common.lib.deployment.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $controllerObject "itemCount" (len $enabledControllers))) | fromYaml -}}
      {{- include "retsamedoc.common.lib.deployment.validate" (dict "rootContext" $rootContext "object" $deploymentObject) -}}
      {{- include "retsamedoc.common.class.deployment" (dict "rootContext" $rootContext "object" $deploymentObject) | nindent 0 -}}

    {{- else if eq $controllerObject.type "cronjob" -}}
      {{- $cronjobObject := (include "retsamedoc.common.lib.cronjob.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $controllerObject "itemCount" (len $enabledControllers))) | fromYaml -}}
      {{- include "retsamedoc.common.lib.cronjob.validate" (dict "rootContext" $rootContext "object" $cronjobObject) -}}
      {{- include "retsamedoc.common.class.cronjob" (dict "rootContext" $rootContext "object" $cronjobObject) | nindent 0 -}}

    {{- else if eq $controllerObject.type "daemonset" -}}
      {{- $daemonsetObject := (include "retsamedoc.common.lib.daemonset.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $controllerObject "itemCount" (len $enabledControllers))) | fromYaml -}}
      {{- include "retsamedoc.common.lib.daemonset.validate" (dict "rootContext" $rootContext "object" $daemonsetObject) -}}
      {{- include "retsamedoc.common.class.daemonset" (dict "rootContext" $rootContext "object" $daemonsetObject) | nindent 0 -}}

    {{- else if eq $controllerObject.type "statefulset"  -}}
      {{- $statefulsetObject := (include "retsamedoc.common.lib.statefulset.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $controllerObject "itemCount" (len $enabledControllers))) | fromYaml -}}
      {{- include "retsamedoc.common.lib.statefulset.validate" (dict "rootContext" $rootContext "object" $statefulsetObject) -}}
      {{- include "retsamedoc.common.class.statefulset" (dict "rootContext" $rootContext "object" $statefulsetObject) | nindent 0 -}}

    {{- else if eq $controllerObject.type "job"  -}}
      {{- $jobObject := (include "retsamedoc.common.lib.job.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $controllerObject "itemCount" (len $enabledControllers))) | fromYaml -}}
      {{- include "retsamedoc.common.lib.job.validate" (dict "rootContext" $rootContext "object" $jobObject) -}}
      {{- include "retsamedoc.common.class.job" (dict "rootContext" $rootContext "object" $jobObject) | nindent 0 -}}
    {{- end -}}

    {{- if $controllerObject.podDisruptionBudget -}}
      {{- $podDisruptionBudgetObject := (include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" (merge (dict "controller" $identifier "forceRename" $controllerObject.name) $controllerObject.podDisruptionBudget))) | fromYaml -}}
      {{- include "retsamedoc.common.lib.podDisruptionBudget.validate" (dict "rootContext" $rootContext "object" $podDisruptionBudgetObject) -}}
      {{- include "retsamedoc.common.class.podDisruptionBudget" (dict "rootContext" $rootContext "object" $podDisruptionBudgetObject) | nindent 0 -}}
    {{- end -}}

    {{- if $controllerObject.horizontalPodAutoscaler -}}
      {{- $hpaObject := (include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" (merge (dict "controller" $identifier "forceRename" $controllerObject.name) $controllerObject.horizontalPodAutoscaler))) | fromYaml -}}
      {{- include "retsamedoc.common.lib.horizontalPodAutoscaler.validate" (dict "rootContext" $rootContext "object" $hpaObject) -}}
      {{- include "retsamedoc.common.class.horizontalPodAutoscaler" (dict "rootContext" $rootContext "object" $hpaObject) | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
