External Helm charts

```
$ ./scripts/external-helm-charts format
$ ./scripts/external-helm-charts download
$ ./scripts/external-helm-charts push
```

Sources:

- https://github.com/grafana/grafana-operator/tree/master/deploy/helm
- https://github.com/grafana/helm-charts/tree/main/charts
- https://github.com/grafana/loki/tree/main/production/helm
- https://github.com/grafana/mimir/tree/main/operations/helm/charts
- https://github.com/grafana/tempo/tree/main/operations/helm
- https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts

```
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
```
