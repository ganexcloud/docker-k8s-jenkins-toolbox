# Contributing

## Versioning

This repository uses independent SemVer starting from `v1.0.0`.

| Increment | When to use |
|---|---|
| **patch** `v1.0.1` | Urgent fix without component upgrades |
| **minor** `v1.1.0` | Component upgrades (Helm, kubectl, Alpine, etc.) |
| **major** `v2.0.0` | Breaking changes or image restructuring |

## Branch strategy

| Branch | Purpose |
|---|---|
| `main` | Base — receives all changes via PR before release |
| `v1.0`, `v1.1`... | Version branches — source for GitHub Releases |

## CI behavior

| Event | Build | DockerHub push |
|---|---|---|
| Pull Request | yes | no |
| GitHub Release published | yes | yes |

Tags published on release: `vX.Y.Z` and `vX.Y` (e.g. `v1.0.0` and `v1.0`)

## Creating a new version

```bash
# 1. Create a feature branch from main
git checkout main && git pull
git checkout -b feat/upgrade-components

# 2. Update Dockerfile and README components table

# 3. Push and open a Pull Request targeting main
git push origin feat/upgrade-components
# GitHub Actions validates the build automatically on the PR

# 4. After merge, create the version branch from main
git checkout main && git pull
git checkout -b v1.1
git push origin v1.1

# 5. Create a GitHub Release targeting the version branch
gh release create v1.1.0 --target v1.1 --title "v1.1.0" --notes "..."
# GitHub Actions builds multi-platform and pushes to DockerHub automatically
```

## Patching an older version

```bash
# 1. Create a fix branch from the version branch
git checkout v1.0
git checkout -b fix/description
git commit -m "fix: description"
git push origin fix/description

# 2. Open a PR targeting the version branch (e.g. v1.0), not main

# 3. After merge, create a GitHub Release
gh release create v1.0.1 --target v1.0 --title "v1.0.1" --notes "..."

# 4. Cherry-pick to main if relevant for future versions
git checkout main && git cherry-pick <commit-hash>
```
