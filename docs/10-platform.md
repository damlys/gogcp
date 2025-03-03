# Internal Developer Platform (IDP)

## Google Cloud Platform projects

- [gogke-main-0](https://console.cloud.google.com/home/dashboard?project=gogke-main-0)
- [gogke-test-0](https://console.cloud.google.com/home/dashboard?project=gogke-test-0)
- [gogke-prod-0](https://console.cloud.google.com/home/dashboard?project=gogke-prod-0)

```
$ gcloud config set project "gogke-main-0"
$ gcloud config set compute/region "europe-central2"
$ gcloud config set compute/zone "europe-central2-a"
```

## Terraform state buckets

- [gogke-main-0-terraform-state](https://console.cloud.google.com/storage/browser/gogke-main-0-terraform-state?project=gogke-main-0)

## Docker images registries

- [europe-central2-docker.pkg.dev/gogke-main-0/public-docker-images](https://console.cloud.google.com/artifacts/docker/gogke-main-0/europe-central2/public-docker-images?project=gogke-main-0)
- [europe-central2-docker.pkg.dev/gogke-main-0/private-docker-images](https://console.cloud.google.com/artifacts/docker/gogke-main-0/europe-central2/private-docker-images?project=gogke-main-0)

```
$ gcloud auth configure-docker "europe-central2-docker.pkg.dev"
```

## Helm charts registries

- [oci://europe-central2-docker.pkg.dev/gogke-main-0/public-helm-charts](https://console.cloud.google.com/artifacts/docker/gogke-main-0/europe-central2/public-helm-charts?project=gogke-main-0)
- [oci://europe-central2-docker.pkg.dev/gogke-main-0/private-helm-charts](https://console.cloud.google.com/artifacts/docker/gogke-main-0/europe-central2/private-helm-charts?project=gogke-main-0)
- [oci://europe-central2-docker.pkg.dev/gogke-main-0/external-helm-charts](https://console.cloud.google.com/artifacts/docker/gogke-main-0/europe-central2/external-helm-charts?project=gogke-main-0)

```
$ gcloud auth print-access-token | helm registry login --username="oauth2accesstoken" --password-stdin "europe-central2-docker.pkg.dev"
```

## Terraform submodules registries

- [gogke-main-0-public-terraform-modules](https://console.cloud.google.com/storage/browser/gogke-main-0-public-terraform-modules?project=gogke-main-0)
- [gogke-main-0-private-terraform-modules](https://console.cloud.google.com/storage/browser/gogke-main-0-private-terraform-modules?project=gogke-main-0)

## Kubernetes clusters

- [gke_gogke-test-0_europe-central2-a_gogke-test-8](https://console.cloud.google.com/kubernetes/clusters/details/europe-central2-a/gogke-test-8/details?project=gogke-test-0)

```
$ gcloud --project="gogke-test-0" container clusters --region="europe-central2-a" get-credentials "gogke-test-8"
$ kubectl config set-context "gke_gogke-test-0_europe-central2-a_gogke-test-8"
$ kubectl config set-context --current --namespace="gomod-test-9"
```
