{{- /*
Returns the value for volumes
*/ -}}
{{- define "retsamedoc.common.lib.pod.field.volumes" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $controllerObject := .ctx.controllerObject -}}

  {{- $persistenceItemsToProcess := dict -}}
  {{- $volumes := list -}}

  {{- range $identifier, $persistenceValues := $rootContext.Values.persistence -}}
    {{- $persistenceEnabled := true -}}
    {{- if hasKey $persistenceValues "enabled" -}}
      {{- $persistenceEnabled = $persistenceValues.enabled -}}
    {{- end -}}

    {{- if $persistenceEnabled -}}
      {{- $hasglobalMounts := not (empty $persistenceValues.globalMounts) -}}
      {{- $globalMounts := dig "globalMounts" list $persistenceValues -}}

      {{- $hasAdvancedMounts := not (empty $persistenceValues.advancedMounts) -}}
      {{- $advancedMounts := dig "advancedMounts" $controllerObject.identifier list $persistenceValues -}}

      {{ if or
        ($hasglobalMounts)
        (and ($hasAdvancedMounts) (not (empty $advancedMounts)))
        (and (not $hasglobalMounts) (not $hasAdvancedMounts))
      -}}
        {{- $_ := set $persistenceItemsToProcess $identifier $persistenceValues -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- range $identifier, $persistenceValues := $persistenceItemsToProcess -}}
    {{- $volume := dict "name" $identifier -}}

    {{- if eq (default "persistentVolumeClaim" $persistenceValues.type) "persistentVolumeClaim" -}}
      {{- $pvcName := (include "retsamedoc.common.lib.chart.names.fullname" $rootContext) -}}
      {{- if $persistenceValues.existingClaim -}}
        {{- /* existingClaim wins over chart-managed PVC name */ -}}
        {{- $pvcName = tpl $persistenceValues.existingClaim  $rootContext -}}
      {{- else -}}
        {{- $object := (include "retsamedoc.common.lib.pvc.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}
        {{- $pvcName = get $object "name" -}}
      {{- end -}}
      {{- $_ := set $volume "persistentVolumeClaim" (dict "claimName" $pvcName) -}}

    {{- else if eq $persistenceValues.type "configMap" -}}
      {{- $objectName := "" -}}
      {{- if $persistenceValues.name -}}
        {{- $objectName = tpl $persistenceValues.name $rootContext -}}
      {{- else if $persistenceValues.identifier -}}
        {{- $object := (include "retsamedoc.common.lib.configMap.getByIdentifier" (dict "rootContext" $rootContext "id" $persistenceValues.identifier) | fromYaml ) -}}
        {{- if not $object -}}
          {{- fail (printf "Persistence '%s': No ConfigMap found with identifier '%s'. Ensure a ConfigMap with this identifier exists and is enabled under 'configMaps.%s'." $identifier $persistenceValues.identifier $persistenceValues.identifier) -}}
        {{- end -}}
        {{- $objectName = $object.name -}}
      {{- end -}}
      {{- $_ := set $volume "configMap" dict -}}
      {{- $_ := set $volume.configMap "name" $objectName -}}
      {{- with $persistenceValues.defaultMode -}}
        {{- $_ := set $volume.configMap "defaultMode" . -}}
      {{- end -}}
      {{- with $persistenceValues.items -}}
        {{- $_ := set $volume.configMap "items" . -}}
      {{- end -}}

    {{- else if eq $persistenceValues.type "secret" -}}
      {{- $objectName := "" -}}
      {{- if $persistenceValues.name -}}
        {{- $objectName = tpl $persistenceValues.name $rootContext -}}
      {{- else if $persistenceValues.identifier -}}
        {{- $object := (include "retsamedoc.common.lib.secret.getByIdentifier" (dict "rootContext" $rootContext "id" $persistenceValues.identifier) | fromYaml ) -}}
        {{- if not $object -}}
          {{- fail (printf "Persistence '%s': No Secret found with identifier '%s'. Ensure a Secret with this identifier exists and is enabled under 'secrets.%s'." $identifier $persistenceValues.identifier $persistenceValues.identifier) -}}
        {{- end -}}
        {{- $objectName = $object.name -}}
      {{- end -}}
      {{- $_ := set $volume "secret" dict -}}
      {{- $_ := set $volume.secret "secretName" $objectName -}}
      {{- with $persistenceValues.defaultMode -}}
        {{- $_ := set $volume.secret "defaultMode" . -}}
      {{- end -}}
      {{- with $persistenceValues.items -}}
        {{- $_ := set $volume.secret "items" . -}}
      {{- end -}}

    {{- else if eq $persistenceValues.type "emptyDir" -}}
      {{- $_ := set $volume "emptyDir" dict -}}
      {{- with $persistenceValues.medium -}}
        {{- $_ := set $volume.emptyDir "medium" . -}}
      {{- end -}}
      {{- with $persistenceValues.sizeLimit -}}
        {{- $_ := set $volume.emptyDir "sizeLimit" . -}}
      {{- end -}}

    {{- else if eq $persistenceValues.type "ephemeral" -}}
      {{- $_ := set $volume "ephemeral" dict -}}
      {{- $vct := dict -}}
      {{- $_ := set $vct "spec" dict -}}
      {{- with $persistenceValues.accessMode -}}
        {{- $_ := set $vct.spec "accessModes" (list .) -}}
      {{- end -}}
      {{- with $persistenceValues.storageClass -}}
        {{- $_ := set $vct.spec "storageClassName" . -}}
      {{- end -}}
      {{- with $persistenceValues.size -}}
        {{- $_ := set $vct.spec "resources" (dict "requests" (dict "storage" .)) -}}
      {{- end -}}
      {{- $_ := set $volume.ephemeral "volumeClaimTemplate" $vct -}}

    {{- else if eq $persistenceValues.type "hostPath" -}}
      {{- $_ := set $volume "hostPath" dict -}}
      {{- $_ := set $volume.hostPath "path" (required "hostPath not set" $persistenceValues.hostPath) -}}
      {{- with $persistenceValues.hostPathType }}
        {{- $_ := set $volume.hostPath "type" . -}}
      {{- end -}}

    {{- /* Image volumes require Kubernetes ≥1.33 */ -}}
    {{- else if and (ge ($rootContext.Capabilities.KubeVersion.Minor | int) 33) (eq $persistenceValues.type "image") -}}
      {{- $_ := set $volume "image" dict -}}
      {{- if kindIs "string" $persistenceValues.image -}}
        {{- $_ := set $volume.image "reference" $persistenceValues.image -}}
      {{- else -}}
        {{- $_ := set $volume.image "reference" (include "retsamedoc.common.lib.imageSpecificationToImage" (dict "rootContext" $rootContext "imageSpec" $persistenceValues.image)) -}}
      {{- end -}}
      {{- with $persistenceValues.pullPolicy -}}
        {{- $_ := set $volume.image "pullPolicy" . -}}
      {{- end -}}

    {{- else if eq $persistenceValues.type "nfs" -}}
      {{- $_ := set $volume "nfs" dict -}}
      {{- $_ := set $volume.nfs "server" (required "server not set" $persistenceValues.server) -}}
      {{- $_ := set $volume.nfs "path" (required "path not set" $persistenceValues.path) -}}

    {{- else if eq $persistenceValues.type "custom" -}}
      {{- $volume = $persistenceValues.volumeSpec -}}
      {{- $_ := set $volume "name" $identifier -}}

    {{- else -}}
      {{- fail (printf "Not a valid persistence.type (%s)" $persistenceValues.type) -}}
    {{- end -}}

    {{- $volumes = append $volumes $volume -}}
  {{- end -}}

  {{- if not (empty $volumes) -}}
    {{- $volumes | toYaml -}}
  {{- end -}}
{{- end -}}
