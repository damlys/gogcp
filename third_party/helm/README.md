External Helm charts

```
$ ./scripts/external-helm-charts download
$ ./scripts/external-helm-charts push
```

Sources:

- https://github.com/cert-manager/cert-manager/tree/master/deploy/charts
- https://github.com/grafana/helm-charts
- https://github.com/istio/istio/tree/master/manifests/charts
- https://github.com/kubernetes-sigs/external-dns/tree/master/charts
- https://github.com/open-telemetry/opentelemetry-helm-charts
- https://github.com/prometheus-community/helm-charts

```
$ helm repo add external-dns https://kubernetes-sigs.github.io/external-dns
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo add istio https://istio-release.storage.googleapis.com/charts
$ helm repo add jetstack https://charts.jetstack.io
$ helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```
