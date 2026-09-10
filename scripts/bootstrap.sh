#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# Always target the local management cluster, regardless of kubectl context.
k8s() {
    sudo microk8s kubectl "$@"
}

if ! command -v microk8s &> /dev/null; then
    echo "Installing MicroK8s..."
    sudo snap install microk8s --classic
fi

echo "Waiting for MicroK8s to be ready..."
sudo microk8s status --wait-ready

echo "Enabling addons..."
sudo microk8s enable dns storage rbac

echo "Installing ArgoCD..."
k8s create namespace argocd --dry-run=client -o yaml | k8s apply -f -
k8s apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for ArgoCD..."
k8s wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

echo "Applying App-of-Apps..."
k8s apply -f "${REPO_ROOT}/argocd/bootstrap/app-of-apps.yaml"

echo "Bootstrap complete!"
