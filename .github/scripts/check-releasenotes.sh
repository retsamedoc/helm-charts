#!/usr/bin/env bash

set -euo pipefail

# Check if release notes have been changed
# Usage ./check-releasenotes.sh path/to/chart

command -v yq >/dev/null 2>&1 || {
  printf >&2 "%s\n" "yq (https://github.com/mikefarah/yq) is not installed. Aborting."
  exit 1
}

repository=$(git rev-parse --show-toplevel)

if [ $# -lt 1 ] || [ -z "${1:-}" ]; then
  printf >&2 "%s\n" "No chart folder has been specified."
  exit 1
fi

root="$1"
chart_file="${root}/Chart.yaml"
if [ ! -f "$chart_file" ]; then
  printf >&2 "File %s does not exist.\n" "${chart_file}"
  exit 1
fi

DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
rel_chart_file=$(realpath --relative-to="${repository}" "${chart_file}")

CURRENT=$(yq e '.annotations."artifacthub.io/changes"' -P "${chart_file}")

if [ "$CURRENT" == "" ] || [ "$CURRENT" == "null" ]; then
  printf >&2 "Changelog annotation has not been set in %s!\n" "$chart_file"
  exit 1
fi

ORIGINAL=$(git show "origin/${DEFAULT_BRANCH}:${rel_chart_file}" | yq e '.annotations."artifacthub.io/changes"' -P -)

if [ "$CURRENT" == "$ORIGINAL" ]; then
  printf >&2 "Changelog annotation has not been updated in %s!\n" "$chart_file"
  exit 1
fi

printf "Releasenotes OK for %s\n" "$chart_file"
