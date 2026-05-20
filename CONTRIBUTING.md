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
| `main` | Single development branch — all changes via PR, all releases tagged from here |
| `release/vX.x` | Maintenance branch — created on demand when patching an older version |

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
# GitHub Actions validates the build on the PR (no DockerHub push)

# 4. After merge, create a GitHub Release targeting main
gh release create v1.1.0 --target main --title "v1.1.0" --notes "..."
# GitHub Actions builds multi-platform and pushes to DockerHub automatically
```

## Patching an older version

```bash
# 1. Create a maintenance branch from the tag
git checkout -b release/v1.x v1.0.0

# 2. Create a fix branch and open a PR targeting release/v1.x
git checkout -b fix/description
git commit -m "fix: description"
git push origin fix/description
# Open PR targeting release/v1.x

# 3. After merge, create a GitHub Release targeting the maintenance branch
gh release create v1.0.1 --target release/v1.x --title "v1.0.1" --notes "..."

# 4. Cherry-pick to main if relevant for future versions
git checkout main && git cherry-pick <commit-hash>
```
