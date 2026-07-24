## Context

The repository manages Kubernetes applications through Argo CD ApplicationSets that discover each local Helm chart from its `config.json`. The unused NetBox chart is the only repository consumer of the Bitnami sealed-secrets API: it contains four `SealedSecret` resources. The sealed-secrets controller is separately declared as an infrastructure chart, and Argo CD Image Updater has a stale NetBox image rule.

The live cluster has a healthy sealed-secrets controller but no `SealedSecret` resources, no `netbox` namespace, and no NetBox Secrets. Infisical is independently healthy and already manages active workload secrets; it is not required for NetBox because NetBox is being removed rather than migrated.

## Goals / Non-Goals

**Goals:**

- Remove every repository declaration that requires or refers to sealed-secrets.
- Remove the unused NetBox application from Argo CD discovery.
- Keep existing Infisical configuration and managed Secrets unaffected.
- Use normal GitOps reconciliation to remove the obsolete cluster resources.

**Non-Goals:**

- Migrating NetBox values or creating new Infisical projects, identities, or static-secret resources.
- Migrating the existing `infisical-credentials` bootstrap Secrets; they remain the root credentials for the established Infisical authentication pattern.
- Changing other applications or their Infisical-managed secret targets.

## Decisions

### Remove entire discovered application directories

Delete `kubernetes/apps/netbox/` and `kubernetes/infrastructure/sealed-secrets/` rather than retaining disabled Helm charts or empty manifests. The ApplicationSets discover applications only when `config.json` exists, so removing each directory removes the corresponding Argo CD Application and lets its resource finalizer remove the managed resources.

Keeping a disabled chart was considered but rejected because it would retain dead configuration and could leave the controller application discoverable.

### Remove stale NetBox image automation

Delete the `namePattern: "netbox"` rule from the Argo CD Image Updater template. The rule only targets the deleted application, so retaining it would preserve configuration that can no longer update a deployed workload.

### Remove the global Kustomize type reference

Delete `kubernetes/base/nameReference.yaml` and its reference from `kubernetes/base/kustomization.yaml`. Its sole entry configures `SealedSecret` name transformations; no manifests remain with that kind, and Kustomize configuration for an uninstalled CRD is unnecessary.

Keeping the entry was considered but rejected because it leaves an obsolete dependency reference and creates confusion about supported secret management.

### Do not create replacement secrets

The sealed values are consumed only by NetBox, which is unused and absent from the cluster. No replacement `InfisicalAuth` or `InfisicalStaticSecret` resources are needed. This avoids recovering, exposing, or re-storing credentials that have no active consumer.

Migrating the values to Infisical was considered but rejected because it would create unneeded long-lived credentials and a project identity solely for a removed workload.

## Risks / Trade-offs

- [Argo CD deletion does not complete or preserve resources is enabled] -> Verify that the `netbox` and `sealed-secrets` Applications, namespace, deployment, and CRD are absent after reconciliation; remove any residual resources through the established GitOps/Application lifecycle before considering the change complete.
- [An undiscovered consumer depends on the sealed-secrets CRD] -> Validate the repository has no `SealedSecret` manifests or sealed-secrets references before removing the operator.
- [Infisical is accidentally altered during cleanup] -> Limit implementation edits to the NetBox directory, sealed-secrets directory, and obsolete Kustomize reference; validate existing Infisical resources remain reconciled.

## Migration Plan

1. Remove the NetBox application directory, its four sealed credential manifests, and its Image Updater rule.
2. Remove the sealed-secrets infrastructure directory and the global Kustomize reference.
3. Reconcile Argo CD and verify the obsolete Applications and their managed resources are gone.
4. Verify the Infisical operator and its existing static-secret resources remain healthy.

Rollback consists of restoring the removed Git paths and reconciling Argo CD. No data migration or secret rotation is involved.

## Open Questions

- None. NetBox is confirmed unused, and no active repository workload uses sealed-secrets.
