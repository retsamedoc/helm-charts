{{/*
Renders the configMap objects required by the chart.
*/}}
{{- define "retsamedoc.common.render.configMaps" -}}
  {{- $rootContext := $ -}}

  {{- $enabledConfigMaps := (include "retsamedoc.common.lib.configMap.enabledConfigmaps" (dict "rootContext" $rootContext) | fromYaml ) -}}

  {{- range $identifier := keys $enabledConfigMaps -}}
    {{- $configMapObject := (include "retsamedoc.common.lib.configMap.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- include "retsamedoc.common.lib.configMap.validate" (dict "rootContext" $rootContext "object" $configMapObject "id" $identifier) -}}

      {{- include "retsamedoc.common.class.configMap" (dict "rootContext" $rootContext "object" $configMapObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}

{{/*
Renders configMap objects required by the chart from a folder in the repo's path.
*/}}
{{- define "retsamedoc.common.render.configMaps.fromFolder" -}}
  {{- $rootContext := $ -}}

  {{- $valuesCopy := $rootContext.Values -}}
  {{- $configMapsFromFolder := $rootContext.Values.configMapsFromFolder | default dict -}}
  {{- $configMapsFromFolderEnabled := dig "enabled" false $configMapsFromFolder -}}

  {{- if $configMapsFromFolderEnabled -}}
    {{- include "retsamedoc.common.lib.configMap.fromFolder.validate" (dict "rootContext" $ "basePath" ($configMapsFromFolder.basePath | default "" )) -}}

    {{- $collected := include "retsamedoc.common.lib.filesFolders.collectFilesfromFolder" (
        dict
        "rootContext" $rootContext
        "basePath" $configMapsFromFolder.basePath
        "fromFolder" $configMapsFromFolder
        "overridesKey" "configMapsOverrides"
      ) | fromYaml
    -}}

    {{- range $folder, $entry := $collected -}}
      {{- $configMapValues := dict
        "enabled" true
        "forceRename" $entry.forceRename
        "labels" $entry.labels
        "annotations" $entry.annotations
        "data" $entry.text
        "binaryData" $entry.binary
      -}}
      {{- $configMapObject := (include "retsamedoc.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $folder "values" $configMapValues) | fromYaml) -}}

      {{- $existingConfigMaps := (get $valuesCopy "configMaps" | default dict) -}}
      {{- $mergedConfigMaps := deepCopy $existingConfigMaps | merge (dict $folder $configMapObject) -}}
      {{- $valuesCopy := merge $valuesCopy (dict "configMaps" $mergedConfigMaps) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
