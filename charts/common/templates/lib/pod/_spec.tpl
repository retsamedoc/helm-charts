{{- /*
The pod definition included in the controller.
*/ -}}
{{- define "retsamedoc.common.lib.pod.spec" -}}
  {{- $rootContext := .rootContext -}}
  {{- $controllerObject := .controllerObject -}}
  {{- $ctx := dict "rootContext" $rootContext "controllerObject" $controllerObject -}}

enableServiceLinks: {{ include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "enableServiceLinks" "default" false) }}
serviceAccountName: {{ include "retsamedoc.common.lib.pod.field.serviceAccountName" (dict "ctx" $ctx) | trim }}
automountServiceAccountToken: {{ include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "automountServiceAccountToken" "default" false) }}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "priorityClassName")) }}
priorityClassName: {{ . | trim }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "runtimeClassName")) }}
runtimeClassName: {{ . | trim }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "schedulerName")) }}
schedulerName: {{ . | trim }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "securityContext")) }}
securityContext: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "hostname")) }}
hostname: {{ . | trim }}
  {{- end }}
hostIPC: {{ include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "hostIPC" "default" false) }}
hostNetwork: {{ include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "hostNetwork" "default" false) }}
hostPID: {{ include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "hostPID" "default" false) }}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "hostUsers")) }}
hostUsers: {{ . | trim }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "shareProcessNamespace")) }}
shareProcessNamespace: {{ . | trim }}
  {{- end }}
dnsPolicy: {{ include "retsamedoc.common.lib.pod.field.dnsPolicy" (dict "ctx" $ctx) | trim }}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "dnsConfig")) }}
dnsConfig: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "hostAliases")) }}
hostAliases: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "imagePullSecrets")) }}
imagePullSecrets: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "terminationGracePeriodSeconds")) }}
terminationGracePeriodSeconds: {{ . | trim }}
  {{- end -}}
  {{- /* Pod-level resources / resourceClaims need Kubernetes ≥1.32; pod resizePolicy needs ≥1.36 */ -}}
  {{- if ge ($rootContext.Capabilities.KubeVersion.Minor | int) 32 }}
    {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "resources")) }}
resources: {{ . | nindent 2 }}
    {{- end -}}
    {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "resourceClaims")) }}
resourceClaims: {{ . | nindent 2 }}
    {{- end -}}
    {{- if ge ($rootContext.Capabilities.KubeVersion.Minor | int) 36 }}
      {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "resizePolicy")) }}
resizePolicy: {{ . | nindent 4 }}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "restartPolicy")) }}
restartPolicy: {{ . | trim }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "nodeSelector")) }}
nodeSelector: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "affinity")) }}
affinity: {{- tpl . $rootContext | nindent 2 }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "topologySpreadConstraints")) }}
topologySpreadConstraints: {{- tpl . $rootContext | nindent 2 }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "tolerations")) }}
tolerations: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.getOption" (dict "ctx" $ctx "option" "schedulingGates")) }}
schedulingGates: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.field.initContainers" (dict "ctx" $ctx) | trim) }}
initContainers: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.field.containers" (dict "ctx" $ctx) | trim) }}
containers: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "retsamedoc.common.lib.pod.field.volumes" (dict "ctx" $ctx) | trim) }}
volumes: {{ . | nindent 2 }}
  {{- end -}}
{{- end -}}
