FROM alpine:3.16
LABEL org.opencontainers.image.title="k8s-jenkins-toolbox" \
  org.opencontainers.image.description="Docker image with common dependencies for Ganex deploy pipelines" \
  org.opencontainers.image.vendor="Ganex" \
  org.opencontainers.image.source="https://github.com/ganexcloud/docker-k8s-jenkins-toolbox"

ARG HELM_VERSION="v3.15.0"
ARG HELM_DIFF_VERSION="3.15.7"
ARG KUBECTL_VERSION="v1.30.0"
ARG GIT_CRYPT_VERSION="0.7.0"
ARG TARGETOS
ARG TARGETARCH

# Install dependencies
RUN set -ex \
    && apk update -qq \
    && apk add --update ca-certificates curl bash zip git g++ aws-cli py-pip \
    && pip3 install requests

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

# Install git-crypt
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        git make openssh openssl openssl-dev \
    && curl -L https://github.com/AGWA/git-crypt/archive/debian/${GIT_CRYPT_VERSION}.tar.gz | tar zxv -C /var/tmp \
    && cd /var/tmp/git-crypt-debian \
    && make \
    && make install PREFIX=/usr/local \
    && apk del --purge .build-deps \
    && rm -rf /var/cache/apk/*

# Install docker-cli
RUN set -ex \
    && apk add docker-cli

CMD ["bash"]
