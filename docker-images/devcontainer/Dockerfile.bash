#!/usr/bin/env bash
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

# docker: https://docs.docker.com/engine/install/debian/#install-using-the-repository
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null

# google: https://cloud.google.com/sdk/docs/install#deb
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

apt update

apt install --yes \
  docker-ce-cli \
  docker-compose-plugin \
  google-cloud-sdk \
  google-cloud-sdk-gke-gcloud-auth-plugin \
  jq \
  kubectl \
  shellcheck

# container-structure-test: https://github.com/GoogleContainerTools/container-structure-test/releases
cst_version="1.19.3"
wget https://github.com/GoogleContainerTools/container-structure-test/releases/download/v${cst_version}/container-structure-test-${TARGETOS}-${TARGETARCH} \
  --output-document=/usr/local/bin/container-structure-test

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
helm completion bash >/etc/bash_completion.d/helm
kubectl completion bash >/etc/bash_completion.d/kubectl
yq shell-completion bash >/etc/bash_completion.d/yq

# cleanup
apt clean && rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
