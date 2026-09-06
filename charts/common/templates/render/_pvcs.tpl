{{/*
Renders the Persistent Volume Claim objects required by the chart
*/}}
{{- define "retsamedoc.common.render.pvcs" -}}
  {{- $rootContext := $ -}}

  {{- $enabledPVCs := (include "retsamedoc.common.lib.pvc.enabledPVCs" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledPVCs -}}
    {{- $pvcObject := (include "retsamedoc.common.lib.pvc.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- include "retsamedoc.common.class.pvc" (dict "rootContext" $rootContext "object" $pvcObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
