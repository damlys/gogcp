{{- define "cert-manager-issuers.metadataLabels" -}}
app.kubernetes.io/part-of: "{{ .Release.Namespace }}"
app.kubernetes.io/instance: "{{ .Release.Name }}"
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}

{{- define "cert-manager-issuers.httpSolver" -}}
ingress: # https://cert-manager.io/docs/configuration/acme/http01/#configuring-the-http01-ingress-solver
  ingressClassName: istio
  class: istio
gatewayHTTPRoute: # https://cert-manager.io/docs/configuration/acme/http01/#configuring-the-http-01-gateway-api-solver
  parentRefs:
    - kind: Gateway
      namespace: traefik
      name: traefik
{{- end -}}
