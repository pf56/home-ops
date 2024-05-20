#!/usr/bin/env bash
# restore key into key.txt first (or create a new on `age-keygen -o key.txt`)
kubectl -n argocd create secret generic helm-secrets-private-keys --from-file=key.txt=key.txt
kubectl kustomize . --enable-helm | kubectl apply -f -
