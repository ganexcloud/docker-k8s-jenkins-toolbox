# k8s-jenkins-toolbox

[![Docker Stars](https://img.shields.io/docker/stars/ganex/k8s-jenkins-toolbox.svg)](https://hub.docker.com/r/ganex/k8s-jenkins-toolbox/)
[![Docker Pulls](https://img.shields.io/docker/pulls/ganex/k8s-jenkins-toolbox.svg)](https://hub.docker.com/r/ganex/k8s-jenkins-toolbox/)

Docker image with common dependencies for Ganex deploy pipelines.

## Included tools

| Tag | Alpine | Helm | kubectl | docker-cli | docker-cli-buildx | git-crypt |
|-----|--------|------|---------|------------|-------------------|-----------|
| `v1.1` | 3.23 | v3.15.0 | v1.33.12 | 29.5.1 | 0.30.1 | 0.7.0 |
| `v1.0` | 3.16 | v3.15.0 | v1.30.0 | 20.x    | —      | 0.7.0 |

Helm plugins: `helm-s3`, `helm-diff` (v3.12.5), `helm-push`

Other packages: `aws-cli`, `bash`, `curl`, `zip`, `git`, `python3`, `requests`

## Usage

```yaml
# Jenkinsfile / GitLab CI
image: ganex/k8s-jenkins-toolbox:v1.0
```
