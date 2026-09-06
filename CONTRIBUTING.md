# Contributing

## Branching

| Work type | Branch name |
| --- | --- |
| Chart change | `feat/$chartname-$target_version` (example: `feat/esphome-2026.3.0`) |
| Repo / CI / docs / tooling | `chore/…` (example: `chore/repo-structure-ci`) |

- Open a pull request into `main`. Do not push incomplete charts to `main`.
- **Squash-merge** only (configure the GitHub repo accordingly).
- Required checks must be green before merge: CI lint, install, pre-commit, and releasenotes (when charts change).

## What belongs on `main`

Only releasable charts under `charts/<name>/`. Development happens on feature/chore branches. Directory name must match `Chart.yaml` `name`.

Reference implementation: [`charts/juicepassproxy`](charts/juicepassproxy).

## Chart checklist

Before opening a PR that touches a chart:

- [ ] `Chart.yaml` `name` equals the directory name
- [ ] `version` bumped for any releasable change; `appVersion` updated when the app image/tag changes
- [ ] `annotations.artifacthub.io/changes` updated for the new chart version
- [ ] Rancher keys in `annotations` (`catalog.cattle.io/display-name`, `catalog.cattle.io/os`)
- [ ] `artifacthub.io/signKey` present (see [SIGNING.md](SIGNING.md))
- [ ] `Chart.lock` committed; vendored `charts/*.tgz` **not** committed (gitignored)
- [ ] `.helmignore`, `ci/ct-values.yaml`, `app-readme.md`, `templates/NOTES.txt`
- [ ] `ct lint` passes in CI; `ct install` for charts not listed in `.github/ct-install.yaml` `excluded-charts`

New charts: copy [`template/chart/`](template/chart/) to `charts/<name>/`, replace `CHART_NAME` / `DISPLAY_NAME` placeholders, then open `feat/<name>-<version>`. Do not merge incomplete charts to `main`.

After Renovate bumps a Helm dependency, you can refresh `artifacthub.io/changes` with:

`python3 .github/scripts/renovate-releasenotes.py <chart-name>`
(see `.github/scripts/requirements.txt`).

## Targets

Primary: **k3s** (current stable) managed by **Rancher**. Ingress: Traefik. Storage: `local-path` unless overridden.

## Signing

Charts are published with Helm PGP provenance (`.prov`) on GitHub Pages and cosign-signed OCI packages on GHCR. See [SIGNING.md](SIGNING.md).

## Maintainer GitHub settings

On the repository:

1. Allow **squash merge** only (disable merge commit / rebase if preferred).
2. Branch protection on `main`: require PR, require status checks (`Lint charts`, `Install successful`, `Run pre-commit checks`, releasenotes when applicable), dismiss stale reviews.
3. Confirm GitHub Pages publishes from the `gh-pages` branch.
