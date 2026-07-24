## Context

`kubernetes/clusters/home-argo/` currently combines a Kustomization with Kustomize's `helmCharts` generator. It renders `argo-cd` chart version `9.1.4` using release name `argocd`, then applies six local manifests: the namespace, the default AppProject, the self-managing Application, the root Application, a custom Argo CD ConfigMap, and Traefik IngressRoutes.

The live self-managing Application is named `argo-cd`, but its generated upstream resources are named with the distinct Helm release name `argocd`. Argo CD selects Helm rendering when `spec.source.helm` is present. This means the release-name seed is required to avoid the default `argo-cd` release name, but it also requires the chart conversion to follow immediately: a Helm source without `Chart.yaml` produces a comparison error.

The repository's established pattern is a local Helm wrapper chart with an upstream dependency, committed `Chart.lock`, values nested under the dependency name, and optional local templates. The generated `charts/` directory is not committed. The current Argo CD resources are reconciled by Argo CD, not by a Helm release.

## Goals / Non-Goals

**Goals:**

- Replace the Kustomization with a local Helm wrapper chart following repository conventions.
- Keep the upstream Argo CD chart at version `9.1.4` and retain all existing Argo CD settings.
- Preserve resource identities, including `argocd-server`, the Argo CD CRDs, AppProject, Applications, and Traefik routes.
- Preserve Argo CD as the reconciler of its own resources.
- Provide a repeatable bootstrap command for a fresh cluster.
- Transition the live application without generating a second set of `argo-cd-*` resources.

**Non-Goals:**

- Upgrade Argo CD or modify its component configuration, notifications, SSH trust, RBAC, or ingress behavior.
- Convert the remaining `snapshot-controller` Kustomization to Helm.
- Create a Helm release or adopt existing Argo CD resources into Helm ownership.
- Change the root ApplicationSet discovery model.

## Decisions

### Use a local wrapper chart with a pinned dependency

Create a `v2` chart in `kubernetes/clusters/home-argo/` whose dependency is `argo-cd` from `https://argoproj.github.io/argo-helm` at version `9.1.4`. Commit the generated `Chart.lock` but not `charts/`, matching other infrastructure charts. Move the current upstream settings beneath an `argo-cd:` key in `values.yaml`, because dependency values are scoped by chart name.

The wrapper's `templates/` directory will contain the six existing local resources. Namespaced local resources will use the Helm release namespace so direct bootstrap rendering and Argo CD rendering target `argocd` consistently.

Alternative considered: retain Kustomize and only move the upstream chart source. This leaves the unique Kustomize Helm-generator dependency and does not align the directory with the repository's chart convention.

### Preserve `argocd` as an explicit Helm release name

The self-managing `Application` template will set `spec.source.helm.releaseName: argocd`. Bootstrap rendering will use the same release name and the `argocd` namespace. This preserves upstream resource names expected by the local Traefik routes and existing cluster resources.

Alternative considered: accept the default `argo-cd` release name. This would rename every upstream resource and require route changes, resource recreation, and a disruptive migration.

### Retain local ConfigMap and Traefik resources as templates

Keep `configs.cm.create: false` and render the existing custom `argocd-cm` locally. The `kustomize.buildOptions: --enable-helm` entry will be removed because no Kustomization in the repository uses Helm generation after this change. Keep the Traefik `IngressRoute` definitions instead of using the upstream Ingress feature, because the current routes explicitly support h2c gRPC traffic and HTTP-to-HTTPS redirect behavior.

Alternative considered: configure ingress entirely through upstream values. This would alter the current Traefik-specific routing model and risks changing gRPC behavior.

### Use a two-phase GitOps transition

First, add `spec.source.helm.releaseName: argocd` to the self-managing Application and synchronize it. This seeds the live release name, but Argo CD immediately treats the source as Helm and reports a comparison error until `Chart.yaml` is available. Existing synchronized resources continue running.

Second, promptly convert the directory to the wrapper chart and synchronize it. Argo CD can then render the wrapper with release name `argocd`, producing the existing resource identities and clearing the comparison error.

Alternative considered: perform the conversion in one sync. Argo CD would render the new chart using its live Application name, `argo-cd`, before applying the new self-Application manifest, causing an unintended parallel resource set.

### Bootstrap by rendering Helm manifests for kubectl apply

The bootstrap script will build the pinned dependency and use `helm template argocd . --namespace argocd --include-crds | kubectl apply -f -`. This maintains the current bootstrap model: Helm renders manifests, and Argo CD becomes their reconciler once running. `--include-crds` is required so a fresh cluster receives the Argo CD CRDs before its Application resources.

Alternative considered: `helm upgrade --install`. Existing resources lack Helm ownership annotations and are already managed by Argo CD. Adopting them would create unnecessary Helm release state and conflicting ownership expectations.

## Risks / Trade-offs

- [Dependency values placed at the wrong level render defaults] -> Nest all existing upstream values under `argo-cd:` and compare rendered resource identities before synchronization.
- [A Helm source is missing `Chart.yaml` during the release-name seed] -> Expect a temporary comparison error, keep the conversion follow-up ready, and verify existing workloads remain healthy until the wrapper chart is synchronized.
- [Fresh bootstrap omits CRDs] -> Render with `--include-crds` and validate that the output contains the three Argo CD CRDs.
- [Custom templates apply to the wrong namespace during bootstrap] -> Render namespaced local resources with `.Release.Namespace` and template using `--namespace argocd`.
- [Changing source type causes drift] -> Keep the chart version, values, resource names, and custom manifests unchanged; inspect the rendered manifest identity set before phase-two sync.
- [Rollback after source conversion] -> Revert to the Kustomization while retaining `spec.source.helm.releaseName: argocd`; the field is harmless to Kustomize and prevents a later conversion from reintroducing the naming issue.

## Migration Plan

1. Prepare and validate the wrapper chart locally without changing the live Argo CD Application.
2. Commit the release-name-only change to the existing Kustomize-managed self-Application and explicitly sync it.
3. Confirm the live Application contains `spec.source.helm.releaseName: argocd` and its existing workloads remain healthy; a temporary Helm comparison error is expected until the chart conversion.
4. Commit the chart conversion, including the dependency lockfile and revised bootstrap script, then explicitly sync the self-managing Application.
5. Confirm Argo CD reports source type Helm, `Synced`, and `Healthy`; confirm the existing services and both Traefik routes still reference `argocd-server`.
6. If phase two fails, revert the chart-conversion commit and sync the still-release-name-seeded Kustomization.

## Open Questions

None. The dependency is already accessible to the repository's Argo CD setup through the same Helm chart repository used by the existing Kustomize generator.
