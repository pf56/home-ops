#!/usr/bin/env bash
set -euo pipefail

helm dependency build
helm template argocd . --namespace argocd --include-crds | kubectl apply -f -
