## Why

The repository still declares the Bitnami sealed-secrets controller and four NetBox SealedSecrets even though NetBox is unused and absent from the cluster. Maintaining an unused secret controller and its CRD adds avoidable operational and security surface.

## What Changes

- Remove the unused NetBox Helm application and its four sealed credential manifests.
- Remove the stale Argo CD Image Updater rule for NetBox.
- Remove the sealed-secrets infrastructure application, including its controller and dedicated namespace.
- Remove the obsolete Kustomize `SealedSecret` name-reference configuration.
- Do not add Infisical projects, identities, or secret resources because no active workload consumes the removed NetBox credentials.

## Capabilities

### New Capabilities
- `sealed-secrets-removal`: Declaratively decommission the unused sealed-secrets and NetBox resources without affecting existing Infisical-managed secrets.

### Modified Capabilities

- None.

## Impact

- Removes `kubernetes/apps/netbox/` and `kubernetes/infrastructure/sealed-secrets/` from Argo CD discovery.
- Removes the NetBox image tracking rule from the Argo CD Image Updater configuration.
- Removes the cluster's sealed-secrets controller, namespace, and SealedSecret CRD through GitOps reconciliation.
- Leaves the Infisical operator, its bootstrap credentials, and existing managed application Secrets unchanged.
