#!/usr/bin/env bash
set -e

# require yq
command -v yq >/dev/null 2>&1 || {
    echo >&2 "yq (https://github.com/mikefarah/yq) is not installed. Aborting."
    exit 1
}

# Absolute path of repository
repository=$(git rev-parse --show-toplevel)
charts_folder="${repository}/charts"
charts_summary_file="${charts_folder}"/README.md

# Gather all charts using the common library, excluding common-test
charts=$(find "${charts_folder}" -name "Chart.yaml" | sort)

echo "# Helm charts overview" > "${charts_summary_file}"

echo "| Chart | Description |" >> "${charts_summary_file}"
echo "| ----- | ----------- |" >> "${charts_summary_file}"
for i in ${charts[@]}
do
    chart_data=($(yq eval '.name, .description' "$i"))
    chart_name="${chart_data[0]}"
    chart_description="${chart_data[@]:1}"
    echo "| [${chart_name}]/${chart_name}) | ${chart_description} |" >> "${charts_summary_file}"
done
