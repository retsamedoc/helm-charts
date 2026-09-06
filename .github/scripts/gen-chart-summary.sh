#!/usr/bin/env bash
set -euo pipefail

# require yq
command -v yq >/dev/null 2>&1 || {
    echo >&2 "yq (https://github.com/mikefarah/yq) is not installed. Aborting."
    exit 1
}

repository=$(git rev-parse --show-toplevel)
charts_folder="${repository}/charts"
charts_summary_file="${charts_folder}/README.md"

mapfile -t chart_files < <(find "${charts_folder}" -mindepth 2 -maxdepth 2 -name "Chart.yaml" | sort)

{
  echo "# Helm charts overview"
  echo ""
  echo "| Chart | Description |"
  echo "| ----- | ----------- |"
  for chart_file in "${chart_files[@]}"; do
    chart_name=$(yq eval '.name' "${chart_file}")
    chart_description=$(yq eval '.description' "${chart_file}")
    echo "| [${chart_name}](${chart_name}/) | ${chart_description} |"
  done
} > "${charts_summary_file}"
