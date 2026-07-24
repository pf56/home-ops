## Why

Argo CD runs helm-secrets, SOPS, age, and several downloaded helper binaries solely to render the `fn-iscsi` democratic-csi values. The only live iSCSI consumer is SABnzbd's disposable, nearly empty `/tmpdata` volume, so the dependency can be removed instead of migrating its secrets.

## What Changes

- **BREAKING** Replace SABnzbd's `tmp-sabnzbd-0` FreeNAS iSCSI scratch volume with a new 128Gi Longhorn volume; its existing contents are intentionally discarded.
- Remove the `fn-iscsi` democratic-csi dependency and its encrypted Helm values while retaining the `node-man` dependency used by static NFS volumes.
- Remove the Helm-secrets integration from the Argo CD repo-server, including the age-key bootstrap secret, helper-tool init container, Helm wrapper, and supported secret value-file schemes.
- Remove the SOPS rule and age recipient dedicated to Argo CD Helm-value decryption.

## Capabilities

### New Capabilities
- `iscsi-helm-secrets-removal`: Decommission the unused FreeNAS iSCSI CSI path and Argo CD Helm-secrets integration after SABnzbd moves its disposable scratch storage to Longhorn.

### Modified Capabilities

- None.

## Impact

- Affects the Sabnzbd StatefulSet and its temporary storage lifecycle; Sabnzbd experiences a controlled restart while its old scratch PVC and FreeNAS iSCSI volume are deleted.
- Affects `kubernetes/infrastructure/democratic-csi/`, `kubernetes/apps/sabnzbd/`, `kubernetes/clusters/home-argo/`, and `.sops.yaml`.
- Removes the `freenas-api-iscsi-csi` StorageClass and `org.democratic-csi.freenas-api-iscsi` driver from the cluster after its PV is deleted.
- Leaves the active `org.democratic-csi.node-manual` static NFS volumes and Longhorn storage unchanged.
