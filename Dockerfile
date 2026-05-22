FROM alpine:3.23
LABEL org.opencontainers.image.title="k8s-jenkins-toolbox" \
  org.opencontainers.image.description="Docker image with common dependencies for Ganex deploy pipelines" \
  org.opencontainers.image.vendor="Ganex" \
  org.opencontainers.image.source="https://github.com/ganexcloud/docker-k8s-jenkins-toolbox"

ARG HELM_VERSION="v3.15.0"
ARG HELM_DIFF_VERSION="3.12.5"
ARG HELM_S3_VERSION="0.17.1"
ARG HELM_PUSH_VERSION="0.11.1"
ARG KUBECTL_VERSION="v1.33.12"
ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache curl bash zip git 'aws-cli>=2' 'aws-cli<3' py3-requests git-crypt docker-cli docker-cli-buildx

# Install Helm
RUN set -ex \
    && curl -sSL "https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS:-linux}-${TARGETARCH:-amd64}.tar.gz" -o helm.tar.gz \
    && curl -sSL "https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS:-linux}-${TARGETARCH:-amd64}.tar.gz.sha256sum" \
        | awk '{print $1"  helm.tar.gz"}' | sha256sum -c - \
    && tar -xf helm.tar.gz \
    && mv "${TARGETOS:-linux}-${TARGETARCH:-amd64}/helm" /usr/local/bin/helm \
    && helm repo add stable https://charts.helm.sh/stable \
    && helm plugin install https://github.com/hypnoglow/helm-s3.git --version "${HELM_S3_VERSION}" \
    && helm plugin install https://github.com/databus23/helm-diff --version "${HELM_DIFF_VERSION}" \
    && helm plugin install https://github.com/chartmuseum/helm-push --version "${HELM_PUSH_VERSION}" \
    && rm -rf helm.tar.gz "${TARGETOS:-linux}-${TARGETARCH:-amd64}/"

# Install kubectl
RUN set -ex \
    && curl -sSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS:-linux}/${TARGETARCH:-amd64}/kubectl" -o /usr/local/bin/kubectl \
    && curl -sSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS:-linux}/${TARGETARCH:-amd64}/kubectl.sha256" -o kubectl.sha256 \
    && echo "$(cat kubectl.sha256)  /usr/local/bin/kubectl" | sha256sum -c - \
    && rm kubectl.sha256 \
    && chmod +x /usr/local/bin/kubectl

CMD ["bash"]
