## Summary

<!-- What and why (1–3 bullets). -->

## Branch

- [ ] `feat/$chartname-$target_version` for chart work (CalVer `YY.M` or `YY.M.r`), or `chore/…` for repo-only work

## Chart checklist (if `charts/` changed)

- [ ] Directory name == `Chart.yaml` `name`
- [ ] `version` / `appVersion` updated as needed
- [ ] `artifacthub.io/changes` updated
- [ ] `Chart.lock` committed; no `charts/*/charts/*.tgz`
- [ ] `.helmignore`, `ci/ct-values.yaml`, `app-readme.md`, `NOTES.txt`
- [ ] Rancher + `artifacthub.io/signKey` annotations present

## Test plan

- [ ] CI lint / install / pre-commit green
- [ ] Releasenotes check green (chart PRs)
