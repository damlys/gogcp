# Artifacts

## Docker images

```
$ ./scripts/docker-image build "kuard"
$ ./scripts/docker-image test "kuard"
$ ./scripts/docker-image pre-publish "kuard"
$ ./scripts/docker-image publish "kuard"
$ ./scripts/docker-image show "kuard"
```

## Helm charts

```
$ ./scripts/helm-chart build "kuard"
$ ./scripts/helm-chart test "kuard"
$ ./scripts/helm-chart pre-publish "kuard"
$ ./scripts/helm-chart publish "kuard"
$ ./scripts/helm-chart show "kuard"
```

## Terraform submodules

```
$ ./scripts/terraform-submodule build "kube-kuard"
$ ./scripts/terraform-submodule test "kube-kuard"
$ ./scripts/terraform-submodule pre-publish "kube-kuard"
$ ./scripts/terraform-submodule publish "kube-kuard"
$ ./scripts/terraform-submodule show "kube-kuard"
```
