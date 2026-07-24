#!/usr/bin/env bash
kubectl kustomize . --enable-helm | kubectl apply -f -
