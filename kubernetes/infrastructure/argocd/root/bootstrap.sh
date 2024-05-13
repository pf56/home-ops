#!/usr/bin/env bash
argocd app create root-app \
  --dest-namespace argocd \
  --dest-server https://kubernetes.default.svc \
  --repo git@git.sr.ht:~pfriedrich/home-ops \
  --path kubernetes/infrastructure/argocd/root
