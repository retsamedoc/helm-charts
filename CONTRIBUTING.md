# Contributing

## Versioning ([CalVer](https://calver.org/))

Chart `version` uses **`YY.M.r`** (two-digit year, month without zero-padding, revision):

| Form | Meaning | Example |
| --- | --- | --- |
| `YY.M.r` | Canonical form in `Chart.yaml` | `26.9.0`, `26.9.1`, `26.12.0` |
| `YY.M` | Shorthand (branches, talk) — same as `YY.M.0` | `26.9` ≡ `26.9.0` |

- Always write the full **`YY.M.r`** in `Chart.yaml` (Helm expects SemVer-shaped `MAJOR.MINOR.PATCH`; omitting `.r` can break lint/release tooling).
- In branch names you may omit `.0`: `feat/common-26.9` means target version `26.9.0`.
- Bump `r` for each releasable change within the same month; start a new month at `.0`.
- `appVersion` stays the upstream app’s own version scheme (not CalVer).
- Migrating an existing chart from the old **`YYYY.M.r`** scheme (e.g. `2026.2.5` → `26.9.0`) looks like a SemVer downgrade to `ct lint`. That one-time paradigm change is intentional; `.github/ct-lint.yaml` has `check-version-increment: false` until all charts use `YY.M.r` (then re-enable).

## Branching

| Work type | Branch name |
| --- | --- |
| Chart change | `feat/$chartname-$target_version` (example: `feat/esphome-26.10` or `feat/esphome-26.10.1`) |
| Repo / CI / docs / tooling | `chore/…` (example: `chore/repo-structure-ci`) |

- Open a pull request into `main`. Do not push incomplete charts to `main`.
- **Squash-merge** only (configure the GitHub repo accordingly).
- Required checks must be green before merge: CI lint, install, pre-commit, and releasenotes (when charts change).

## What belongs on `main`

Only releasable charts under `charts/<name>/`. Development happens on feature/chore branches. Directory name must match `Chart.yaml` `name`.

This repository is for homelab apps that do not publish an official Helm chart. If upstream already ships one, use that chart instead of adding a wrapper here.

Reference application chart: [`charts/juicepassproxy`](charts/juicepassproxy).

Shared library: [`charts/common`](charts/common) (`type: library`, helpers `retsamedoc.common.*`, CalVer). Application charts depend on it; do not install `common` standalone.

## Chart checklist

Before opening a PR that touches a chart:

- [ ] No official upstream Helm chart exists for this app (use that chart instead)
- [ ] `Chart.yaml` `name` equals the directory name
- [ ] `maintainers[].name` is a **GitHub username** (this repo: `retsamedoc`), not a display name — `ct lint` looks the name up on GitHub and fails with 404 otherwise
- [ ] `version` bumped (`YY.M.r` CalVer) for any releasable change; `appVersion` updated when the app image/tag changes
- [ ] `annotations.artifacthub.io/changes` updated for the new chart version
- [ ] Rancher keys in `annotations` (`catalog.cattle.io/display-name`, `catalog.cattle.io/os`)
- [ ] Library charts also set `catalog.cattle.io/hidden: "true"` so Rancher Apps / the store never list them
- [ ] `artifacthub.io/signKey` present (see [SIGNING.md](SIGNING.md))
- [ ] `Chart.lock` committed; vendored `charts/*.tgz` **not** committed (gitignored)
- [ ] `.helmignore`, `ci/ct-values.yaml`, `app-readme.md`, `templates/NOTES.txt` (application charts)
- [ ] `ct lint` passes in CI; `ct install` for charts not listed in `.github/ct-install.yaml` `excluded-charts`
- [ ] Library changes: `helm unittest charts/common/test-chart` is green (CI runs this when `charts/common/**` changes)

New charts: copy [`template/chart/`](template/chart/) to `charts/<name>/`, replace `CHART_NAME` / `DISPLAY_NAME` placeholders, then open `feat/<name>-<version>`. Do not merge incomplete charts to `main`.

After Renovate bumps a Helm dependency, you can refresh `artifacthub.io/changes` with:

`python3 .github/scripts/renovate-releasenotes.py <chart-name>`
(see `.github/scripts/requirements.txt`).

## Common library notes

- Helpers are namespaced `retsamedoc.common.*` (see [`charts/common/README.md`](charts/common/README.md)).
- Top-level NetworkPolicy values key is **`networkPolicy`** (singular). Upstream bjw-s used `networkpolicies`; use `networkPolicy` when migrating.
- Gateway API: values under `route:` and `backendTLSPolicy:`. Install Gateway API CRDs on the cluster (k3s does not ship them). Do not add chart-owned `Gateway` / `GatewayClass` objects here — attach Routes via `parentRefs`.
- Local unit tests:

```bash
helm plugin install https://github.com/helm-unittest/helm-unittest.git   # once
helm dependency update charts/common/test-chart
helm unittest -f 'unittests/*_test.yaml' charts/common/test-chart
```

## Targets

Primary: **k3s** (current stable) managed by **Rancher**. Ingress: Traefik (and/or Gateway API when CRDs are installed). Storage: `local-path` unless overridden.

## Signing

Charts are published with Helm PGP provenance (`.prov`) on GitHub Pages and cosign-signed OCI packages on GHCR. See [SIGNING.md](SIGNING.md).

## Maintainer GitHub settings

On the repository:

1. Allow **squash merge** only (disable merge commit / rebase if preferred).
2. Branch protection on `main`: require PR, require status checks (`Lint charts`, `Install successful`, `Run pre-commit checks`, releasenotes when applicable), dismiss stale reviews.
3. Confirm GitHub Pages publishes from the `gh-pages` branch.
