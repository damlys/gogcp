#!/bin/bash
set -ex

cd /tmp
apt update

# basic packages
apt install --yes \
  apt-transport-https \
  bash-completion \
  build-essential \
  ca-certificates \
  curl \
  git \
  gnupg \
  htop \
  iputils-ping \
  less \
  lsb-release \
  man \
  nmap \
  openssh-client \
  sudo \
  tar \
  tree \
  unzip \
  vim \
  wget \
  zip

echo "ALL ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

# golang: https://go.dev/dl/
go_version="1.23.4"
wget https://go.dev/dl/go${go_version}.${TARGETOS}-${TARGETARCH}.tar.gz \
  --output-document=/tmp/go.tar.gz
tar --directory=/usr/local -zxvf go.tar.gz

# docker: https://docs.docker.com/engine/install/debian/#install-using-the-repository
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null

# github: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list >/dev/null

# google: https://cloud.google.com/sdk/docs/install#deb
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# goreleaser: https://goreleaser.com/install/#apt
echo "deb [trusted=yes] https://repo.goreleaser.com/apt/ /" | tee /etc/apt/sources.list.d/goreleaser.list

apt update

apt install --yes \
  docker-ce-cli \
  docker-compose-plugin \
  gh \
  google-cloud-sdk \
  google-cloud-sdk-gke-gcloud-auth-plugin \
  jq \
  kubectl \
  shellcheck

apt install --yes --no-install-recommends \
  goreleaser

go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/posener/complete/gocomplete@v1.2.3
go install golang.org/x/tools/cmd/gonew@latest
go install golang.org/x/tools/gopls@latest
go install golang.org/x/vuln/cmd/govulncheck@latest

# cmctl: https://github.com/cert-manager/cmctl/releases
cmctl_version="2.1.1"
wget https://github.com/cert-manager/cmctl/releases/download/v${cmctl_version}/cmctl_${TARGETOS}_${TARGETARCH} \
  --output-document=/usr/local/bin/cmctl

# container-structure-test: https://github.com/GoogleContainerTools/container-structure-test/releases
cst_version="1.19.3"
wget https://github.com/GoogleContainerTools/container-structure-test/releases/download/v${cst_version}/container-structure-test-${TARGETOS}-${TARGETARCH} \
  --output-document=/usr/local/bin/container-structure-test

# golangci-lint: https://github.com/golangci/golangci-lint/releases
golangci_lint_version="1.62.2"
wget https://github.com/golangci/golangci-lint/releases/download/v${golangci_lint_version}/golangci-lint-${golangci_lint_version}-${TARGETOS}-${TARGETARCH}.tar.gz \
  --output-document=/tmp/golangci-lint.tar.gz
tar -zxvf golangci-lint.tar.gz
mv golangci-lint-${golangci_lint_version}-${TARGETOS}-${TARGETARCH}/golangci-lint /usr/local/bin/golangci-lint

# hclq: https://github.com/mattolenik/hclq/releases
hclq_version="0.5.3"
wget https://github.com/mattolenik/hclq/releases/download/${hclq_version}/hclq-${TARGETOS}-$([ "$TARGETARCH" = "arm64" ] && echo "arm" || echo "$TARGETARCH") \
  --output-document=/usr/local/bin/hclq

# helm: https://github.com/helm/helm/releases
helm_version="3.16.3"
wget https://get.helm.sh/helm-v${helm_version}-${TARGETOS}-${TARGETARCH}.tar.gz \
  --output-document=/tmp/helm.tar.gz
tar -zxvf helm.tar.gz
mv ${TARGETOS}-${TARGETARCH}/helm /usr/local/bin/helm

# istioctl: https://github.com/istio/istio/releases
istioctl_version="1.24.2"
export ISTIO_VERSION="${istioctl_version}" && curl -L https://istio.io/downloadIstio | sh -
mv istio-${istioctl_version}/bin/istioctl /usr/local/bin/istioctl
mv istio-${istioctl_version}/tools/istioctl.bash /etc/bash_completion.d/istioctl

# shfmt: https://github.com/mvdan/sh/releases
shfmt_version="3.10.0"
wget https://github.com/mvdan/sh/releases/download/v${shfmt_version}/shfmt_v${shfmt_version}_${TARGETOS}_${TARGETARCH} \
  --output-document=/usr/local/bin/shfmt

# terraform: https://developer.hashicorp.com/terraform/downloads
terraform_version="1.9.8"
wget https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_${TARGETOS}_${TARGETARCH}.zip \
  --output-document=/tmp/terraform.zip
unzip terraform.zip
mv terraform /usr/local/bin/terraform

# yq: https://github.com/mikefarah/yq/releases
yq_version="4.44.5"
wget https://github.com/mikefarah/yq/releases/download/v${yq_version}/yq_${TARGETOS}_${TARGETARCH} \
  --output-document=/usr/local/bin/yq

# executable files
chmod a+x /usr/local/bin/*

# shell completions
cmctl completion bash >/etc/bash_completion.d/cmctl
gh completion -s bash >/etc/bash_completion.d/gh
golangci-lint completion bash >/etc/bash_completion.d/golangci-lint
goreleaser completion bash >/etc/bash_completion.d/goreleaser
helm completion bash >/etc/bash_completion.d/helm
kubectl completion bash >/etc/bash_completion.d/kubectl
yq shell-completion bash >/etc/bash_completion.d/yq

# cleanup
apt clean && rm -rf /var/lib/apt/lists/*
go clean -cache && rm -rf /root/.cache/go-build/*
go clean -modcache && rm -rf /root/go/pkg/mod/*
rm -rf /tmp/*
