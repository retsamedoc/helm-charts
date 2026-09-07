# Chart signing

This repository dual-publishes charts:

1. **Classic Helm repo** on GitHub Pages (`https://retsamedoc.github.io/helm-charts`) with PGP provenance (`.tgz` + `.tgz.prov`) for Artifact Hub’s Signed badge and `helm pull --verify`.
2. **OCI** on GHCR (`oci://ghcr.io/retsamedoc/charts/<name>`) signed with **keyless cosign** (GitHub Actions OIDC).

## One-time: create the Helm PGP signing key

Run locally (dedicated key, not a personal day-to-day key):

```bash
gpg --full-generate-key
# RSA 4096, no expiry (or long expiry), name e.g. "retsamedoc helm-charts"
# email: retsamedoc@digitalactionsproject.org

gpg --list-secret-keys --keyid-format long
# note the fingerprint

gpg --armor --export-secret-keys <FINGERPRINT> > helm-signing-private.asc
gpg --armor --export <FINGERPRINT> > pgp-public-key.asc
```

Add GitHub Actions **secrets** (Settings → Secrets and variables → Actions):

| Secret | Value |
| --- | --- |
| `HELM_GPG_PRIVATE_KEY` | Full contents of `helm-signing-private.asc` |
| `HELM_GPG_PASSPHRASE` | Passphrase for that key (empty string secret if none) |
| `HELM_GPG_KEY_NAME` | Key uid / email used with `helm package --sign --key` |
| `HELM_GPG_FINGERPRINT` | 40-char fingerprint (no spaces) |

Charts and `template/chart` use fingerprint `40D16531ADC81528315B65664C77EFEB7F669F40` in `artifacthub.io/signKey`. If you rotate the key, update that annotation everywhere to match `HELM_GPG_FINGERPRINT`.

The release workflow exports the public key to `https://retsamedoc.github.io/helm-charts/pgp-public-key.asc` on each release.

Release **fails closed** if these secrets are missing (except `HELM_GPG_PASSPHRASE`, which may be an empty string).

The release workflow exports the secret key with `--pinentry-mode loopback` and `HELM_GPG_PASSPHRASE` so GPG can unlock it in Actions without a TTY (otherwise export fails with `Inappropriate ioctl for device` / `nothing exported`).

## Verify (HTTP / provenance)

```bash
curl -fsSL -o /tmp/pgp-public-key.asc \
  https://retsamedoc.github.io/helm-charts/pgp-public-key.asc
gpg --import /tmp/pgp-public-key.asc

helm repo add retsamedoc https://retsamedoc.github.io/helm-charts
helm repo update
helm pull retsamedoc/<chart> --version <version> --verify --keyring ~/.gnupg/pubring.gpg
```

## Verify (OCI / cosign)

```bash
helm pull oci://ghcr.io/retsamedoc/charts/<chart> --version <version>

# Keyless signature from GitHub Actions OIDC
cosign verify \
  --certificate-identity-regexp='https://github.com/retsamedoc/helm-charts/.github/workflows/.*' \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  ghcr.io/retsamedoc/charts/<chart>:<version>
```

Exact identity regexp may be tightened to the release workflow path after the first signed OCI push.

## Artifact Hub

- Repository ownership ID is in [`artifacthub-repo.yml`](artifacthub-repo.yml) (`c42a5730-11bc-4457-b7c7-4d33837bdf38`).
- HTTP charts need `.prov` next to packages plus `artifacthub.io/signKey` for the Signed badge.
- Cosign recognition applies to the OCI distribution path.

## After first signed release

1. Confirm `.tgz` and `.tgz.prov` appear on `gh-pages`.
2. Confirm `pgp-public-key.asc` and `artifacthub-repo.yml` are on Pages.
3. Confirm Artifact Hub shows Signed after the next crawl.
4. Confirm the README Artifact Hub badge still resolves for `retsamedoc`.
