{{- define "retsamedoc.common.lib.controller.metadata.labels" -}}
  {{-
    $labels := (
      merge
        (.Values.controller.labels | default dict)
        (include "retsamedoc.common.lib.metadata.allLabels" $ | fromYaml)
    )
  -}}
  {{- with $labels -}}
    {{- toYaml . -}}
  {{- end -}}
{{- end -}}

{{- define "retsamedoc.common.lib.controller.metadata.annotations" -}}
  {{-
    $annotations := (
      merge
        (.Values.controller.annotations | default dict)
        (include "retsamedoc.common.lib.metadata.globalAnnotations" $ | fromYaml)
    )
  -}}
  {{- with $annotations -}}
    {{- toYaml . -}}
  {{- end -}}
{{- end -}}
