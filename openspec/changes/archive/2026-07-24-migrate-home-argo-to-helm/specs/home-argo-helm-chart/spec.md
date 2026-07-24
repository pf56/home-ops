## ADDED Requirements

### Requirement: Helm wrapper chart
The repository SHALL define `kubernetes/clusters/home-argo/` as a Helm v2 wrapper chart with a pinned dependency on `argo-cd` chart version `9.1.4` from the Argo Helm repository. The wrapper SHALL retain a committed dependency lockfile and SHALL not require generated chart archives to be committed.

#### Scenario: Dependency resolves reproducibly
- **WHEN** Helm builds dependencies for the home Argo chart
- **THEN** it resolves the locked `argo-cd` version `9.1.4`

### Requirement: Existing Argo CD configuration and identities are preserved
The wrapper chart SHALL render the existing Argo CD configuration, namespace, AppProject, self-managing Application, root Application, and Traefik routes. It MUST use Helm release name `argocd` in namespace `argocd`, and it MUST preserve the existing `argocd-*` resource identities and route backends.

#### Scenario: Chart is rendered for the home cluster
- **WHEN** the wrapper chart is rendered with release name `argocd` and namespace `argocd`
- **THEN** the rendered Argo CD server Service is named `argocd-server`
- **THEN** both rendered Traefik routes target `argocd-server` on port `80`

#### Scenario: Custom configuration remains authoritative
- **WHEN** the wrapper chart is rendered
- **THEN** it renders the custom `argocd-cm` ConfigMap instead of an upstream-generated ConfigMap
- **THEN** the ConfigMap does not configure Kustomize Helm build options

### Requirement: Safe self-managed source transition
The self-managing Argo CD Application SHALL specify `spec.source.helm.releaseName: argocd`. The migration MUST seed this field before changing the source directory into a Helm chart and MUST promptly follow it with the chart conversion because Argo CD selects Helm rendering when Helm source settings are present.

#### Scenario: Release name is seeded before chart conversion
- **WHEN** the release-name-only migration phase is synchronized
- **THEN** the live self-managing Application contains Helm release name `argocd`
- **THEN** existing Argo CD workloads retain their resource identities while the Application reports a Helm comparison error until `Chart.yaml` is available

#### Scenario: Chart conversion is synchronized
- **WHEN** the wrapper-chart migration phase is synchronized after release-name seeding
- **THEN** Argo CD renders the application as Helm using release name `argocd`
- **THEN** the application reaches Synced and Healthy without creating an `argo-cd-server` Service

### Requirement: Bootstrap renders rather than owns the installation
The bootstrap command SHALL build the chart dependency and render the wrapper chart with release name `argocd`, namespace `argocd`, and included CRDs before applying the rendered manifests with kubectl. It MUST NOT create or upgrade a Helm release.

#### Scenario: Fresh cluster bootstrap
- **WHEN** the bootstrap command runs against a cluster without Argo CD
- **THEN** its rendered output includes the Argo CD CRDs and the `argocd` Namespace
- **THEN** it applies manifests without creating Helm release ownership metadata
