FROM alpine:3.23
LABEL org.opencontainers.image.title="k8s-jenkins-toolbox" \
  org.opencontainers.image.description="Docker image with common dependencies for Ganex deploy pipelines" \
  org.opencontainers.image.vendor="Ganex" \
  org.opencontainers.image.source="https://github.com/ganexcloud/docker-k8s-jenkins-toolbox"

ARG HELM_VERSION="v3.15.0"
ARG HELM_DIFF_VERSION="3.12.5"
ARG KUBECTL_VERSION="v1.33.12"
ARG TARGETOS
ARG TARGETARCH

# Install dependencies
RUN set -ex \
    && apk update -qq \
    && apk add --no-cache curl bash zip git py-pip git-crypt docker-cli docker-cli-buildx \
    && pip3 install --break-system-packages 'awscli<2' requests

# Install Helm
RUN set -ex \
    && curl -sSL https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS:-linux}-${TARGETARCH:-amd64}.tar.gz -o helm.tar.gz \
    && tar -xvf helm.tar.gz \
    && mv ${TARGETOS:-linux}-${TARGETARCH:-amd64}/helm /usr/local/bin \
    && helm repo add stable https://charts.helm.sh/stable \
    && helm plugin install https://github.com/hypnoglow/helm-s3.git \
    && helm plugin install https://github.com/databus23/helm-diff --version ${HELM_DIFF_VERSION} \
    && helm plugin install https://github.com/chartmuseum/helm-push \
    && rm -f helm.tar.gz

# Install kubectl
RUN set -ex \
    && curl -sSL https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS:-linux}/${TARGETARCH:-amd64}/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

CMD ["bash"]
