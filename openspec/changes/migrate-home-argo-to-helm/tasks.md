## 1. Seed the Helm release name

- [x] 1.1 Add `spec.source.helm.releaseName: argocd` to the existing Kustomize-managed self-managing Argo CD Application.
- [x] 1.2 Render and validate the release-name-only resource delta, then explicitly synchronize the revision.
- [x] 1.3 Verify the live `argo-cd` Application records Helm release name `argocd` and that existing workloads remain healthy while the Helm comparison error awaits chart conversion.

## 2. Build the Helm wrapper chart

- [x] 2.1 Create the Helm v2 wrapper `Chart.yaml` with the pinned `argo-cd` `9.1.4` dependency and generate its committed `Chart.lock`.
- [x] 2.2 Nest the existing upstream Argo CD values under `argo-cd:` without changing notification, SSH, or server settings.
- [x] 2.3 Move the namespace, AppProject, self-managing Application, root Application, custom ConfigMap, and Traefik routes into Helm templates, preserving resource names and applying `.Release.Namespace` to namespaced local resources.
- [x] 2.4 Keep `configs.cm.create: false`, remove `kustomize.buildOptions: --enable-helm`, and ensure the self-managing Application keeps `helm.releaseName: argocd`.
- [x] 2.5 Remove the Kustomization and old `base/` layout, retain the generated-chart ignore rule, and update `bootstrap.sh` to build dependencies and render with `argocd`, `argocd`, and `--include-crds` before kubectl apply.

## 3. Validate and transition the source

- [x] 3.1 Run Helm dependency, lint, and template validation; verify the output contains the Argo CD CRDs, `argocd` Namespace, `argocd-server` Service, and both routes targeting that service.
- [x] 3.2 Compare rendered resource identities with the current installation and confirm no `argo-cd-server` resource is introduced.
- [ ] 3.3 Explicitly synchronize the chart-conversion revision and verify the live `argo-cd` Application reports Helm source type, Synced, and Healthy.
- [ ] 3.4 Verify the Argo CD server routes remain reachable and document the Kustomize rollback path with the release name retained.
