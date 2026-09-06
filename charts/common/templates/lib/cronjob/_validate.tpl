{{/*
Validate CronJob values
*/}}
{{- define "retsamedoc.common.lib.cronjob.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $cronjobValues := .object -}}

  {{- if and (ne $cronjobValues.pod.restartPolicy "Never") (ne $cronjobValues.pod.restartPolicy "OnFailure") -}}
    {{- fail (printf "CronJob '%s': Invalid restartPolicy '%s'. Valid options are 'Never' or 'OnFailure'. Specify a valid restartPolicy under 'controllers.%s.pod.restartPolicy'." $cronjobValues.identifier $cronjobValues.pod.restartPolicy $cronjobValues.identifier) }}
  {{- end -}}
{{- end -}}
