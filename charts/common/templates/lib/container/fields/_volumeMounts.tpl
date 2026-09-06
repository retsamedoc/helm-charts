{{/*
volumeMounts used by the container.
*/}}
{{- define "retsamedoc.common.lib.container.field.volumeMounts" -}}
  {{- $ctx := .ctx -}}
  {{- $rootContext := $ctx.rootContext -}}
  {{- $controllerObject := $ctx.controllerObject -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- $persistenceItemsToProcess := dict -}}
  {{- $enabledVolumeMounts := list -}}

  {{- range $identifier, $persistenceValues := $rootContext.Values.persistence -}}
    {{- $persistenceEnabled := true -}}
    {{- if hasKey $persistenceValues "enabled" -}}
      {{- $persistenceEnabled = $persistenceValues.enabled -}}
    {{- end -}}

    {{- if $persistenceEnabled -}}
      {{- $_ := set $persistenceItemsToProcess $identifier $persistenceValues -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty (dig "statefulset" "volumeClaimTemplates" nil $controllerObject)) -}}
    {{- range $persistenceValues := $controllerObject.statefulset.volumeClaimTemplates -}}
      {{- $persistenceEnabled := true -}}
      {{- if hasKey $persistenceValues "enabled" -}}
        {{- $persistenceEnabled = $persistenceValues.enabled -}}
      {{- end -}}

      {{- if $persistenceEnabled -}}
        {{- $mountValues := dict -}}
        {{- if not (empty (dig "globalMounts" nil $persistenceValues)) -}}
          {{- $_ := set $mountValues "globalMounts" $persistenceValues.globalMounts -}}
        {{- end -}}
        {{- if not (empty (dig "advancedMounts" nil $persistenceValues)) -}}
          {{- $_ := set $mountValues "advancedMounts" (dict $controllerObject.identifier $persistenceValues.advancedMounts) -}}
        {{- end -}}
        {{- $_ := set $persistenceItemsToProcess $persistenceValues.name $mountValues -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- range $identifier, $persistenceValues := $persistenceItemsToProcess -}}

    {{- $mountPath := (printf "/%v" $identifier) -}}
    {{- if eq "hostPath" (default "persistentVolumeClaim" $persistenceValues.type) -}}
      {{- $mountPath = $persistenceValues.hostPath -}}
    {{- end -}}

    {{- if or .globalMounts .advancedMounts -}}
      {{- $mounts := list -}}
      {{- if hasKey . "globalMounts" -}}
        {{- $mounts = .globalMounts -}}
      {{- end -}}

      {{- if hasKey . "advancedMounts" -}}
        {{- $advancedMounts := dig $controllerObject.identifier $containerObject.identifier list .advancedMounts -}}
        {{- range $advancedMounts -}}
          {{- $mounts = append $mounts . -}}
        {{- end -}}
      {{- end -}}

      {{- range $mounts -}}
        {{- $volumeMount := dict -}}
        {{- $_ := set $volumeMount "name" $identifier -}}

        {{- with .path -}}
          {{- $mountPath = (tpl . $rootContext) -}}
        {{- end -}}
        {{- $_ := set $volumeMount "mountPath" $mountPath -}}

        {{- with .subPath -}}
          {{- $_ := set $volumeMount "subPath" (tpl . $rootContext) -}}
        {{- end -}}

        {{- with .subPathExpr -}}
          {{- $_ := set $volumeMount "subPathExpr" . -}}
        {{- end -}}

        {{- with .readOnly -}}
          {{- $_ := set $volumeMount "readOnly" . -}}
        {{- end -}}

        {{- with .mountPropagation -}}
          {{- $_ := set $volumeMount "mountPropagation" . -}}
        {{- end -}}

        {{- $enabledVolumeMounts = append $enabledVolumeMounts $volumeMount -}}
      {{- end -}}

    {{- else -}}
      {{- $volumeMount := dict -}}
      {{- $_ := set $volumeMount "name" $identifier -}}
      {{- $_ := set $volumeMount "mountPath" $mountPath -}}
      {{- $enabledVolumeMounts = append $enabledVolumeMounts $volumeMount -}}
    {{- end -}}
  {{- end -}}

  {{- with $enabledVolumeMounts -}}
    {{- . | toYaml -}}
  {{- end -}}
{{- end -}}
