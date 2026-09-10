#!/bin/bash
# Render every Kustomization without contacting or modifying a cluster.
# Remote bases require network access. Kubernetes CRD validation is separate.
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

command -v kubectl >/dev/null
status=0
while IFS= read -r -d '' manifest; do
    directory="${manifest%/*}"
    printf 'Checking %s\n' "$directory"
    if ! kubectl kustomize "$directory" >/dev/null; then
        status=1
    fi
done < <(find argocd cluster hardware -name kustomization.yaml -print0)

for script in scripts/*.sh; do
    if ! bash -n "$script"; then
        status=1
    fi
done

exit "$status"
