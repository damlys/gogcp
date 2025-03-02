{{- define "kuard.selectorLabels" -}}
app.kubernetes.io/part-of: "{{ .Release.Namespace }}"
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/name: "{{ join "-" (reverse (slice (reverse (splitList "/" .Values.image.repository)) 0 3)) }}"
{{- end -}}

{{- define "kuard.metadataLabels" -}}
{{ include "kuard.selectorLabels" $ }}
app.kubernetes.io/version: "{{ .Values.image.tag }}"
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}

{{- define "kuard.configsChecksum" -}}
{{- list .Values.configEnvs .Values.secretConfigEnvs .Values.configFiles .Values.secretConfigFiles | toJson | sha256sum -}}
{{- end -}}
