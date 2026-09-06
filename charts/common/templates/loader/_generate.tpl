{{/*
Secondary entrypoint and primary loader for the common chart
*/}}
{{- define "retsamedoc.common.loader.generate" -}}
  {{- $rootContext := $ -}}

  {{- /* Run global chart validations */ -}}
  {{- include "retsamedoc.common.lib.chart.validate" $rootContext -}}

  {{- /* Build the templates */ -}}
  {{- include "retsamedoc.common.render.pvcs" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.serviceAccount" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.configMaps.fromFolder" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.configMaps" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.secrets.fromFolder" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.controllers" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.services" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.ingresses" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.serviceMonitors" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.podMonitors" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.routes" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.backendTLSPolicies" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.secrets" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.networkpolicies" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.rawResources" $rootContext | nindent 0 -}}
  {{- include "retsamedoc.common.render.rbac" $rootContext | nindent 0 -}}
{{- end -}}
