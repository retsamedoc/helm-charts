{{/*
Return the enabled PVCs.
*/}}
{{- define "retsamedoc.common.lib.pvc.enabledPVCs" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledPVCs := dict -}}

  {{- range $identifier, $persistenceItem := $rootContext.Values.persistence -}}
    {{- if kindIs "map" $persistenceItem -}}
      {{- $pvcEnabled := true -}}
      {{- if hasKey $persistenceItem "enabled" -}}
        {{- $pvcEnabled = $persistenceItem.enabled -}}
      {{- end -}}

      {{- if and $pvcEnabled (eq (default "persistentVolumeClaim" $persistenceItem.type) "persistentVolumeClaim") (not $persistenceItem.existingClaim) -}}
        {{- $_ := set $enabledPVCs $identifier . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledPVCs | toYaml -}}
{{- end -}}
