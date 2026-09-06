[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/retsamedoc)](https://artifacthub.io/packages/search?repo=retsamedoc)

Helm charts for home-lab apps, published as a classic Helm repository on GitHub Pages and as OCI packages on GHCR.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.

### Classic repo (GitHub Pages)

```console
helm repo add retsamedoc https://retsamedoc.github.io/helm-charts
helm repo update
helm search repo retsamedoc
helm install <release> retsamedoc/<chart>
```

### OCI (GHCR)

```console
helm install <release> oci://ghcr.io/retsamedoc/charts/<chart> --version <version>
```

Signed packages: see [SIGNING.md](SIGNING.md) for PGP provenance and cosign verification.

## Supported targets

- **Primary:** k3s (current stable) managed by **Rancher**
- **Ingress:** Traefik (k3s default)
- **Storage:** `local-path` unless overridden

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Chart versions use [CalVer](https://calver.org/) `YY.M.r`. Chart work uses `feat/$chartname-$target_version`; repo-only work uses `chore/…`. PRs must pass CI and are squash-merged to `main`.

Reference chart: [`charts/juicepassproxy`](charts/juicepassproxy).
