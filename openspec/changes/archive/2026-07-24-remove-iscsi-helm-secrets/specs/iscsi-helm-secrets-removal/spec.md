## ADDED Requirements

### Requirement: Sabnzbd scratch storage uses Longhorn
The Sabnzbd StatefulSet SHALL provision its 128Gi `tmp-sabnzbd-0` scratch claim with the `longhorn` StorageClass and mount it at `/tmpdata`.

#### Scenario: Scratch claim is recreated after iSCSI decommissioning
- **WHEN** the Sabnzbd StatefulSet is reconciled after its former `tmp-sabnzbd-0` claim is deleted
- **THEN** Kubernetes MUST bind a newly provisioned Longhorn PV to `tmp-sabnzbd-0`

#### Scenario: Discarded scratch data is not migrated
- **WHEN** the former iSCSI scratch claim is removed
- **THEN** the replacement Longhorn claim MUST start without copying data from the former claim

### Requirement: FreeNAS iSCSI CSI path is decommissioned
The repository SHALL not declare the `fn-iscsi` democratic-csi dependency, the `freenas-api-iscsi-csi` StorageClass, or the `org.democratic-csi.freenas-api-iscsi` driver after the former scratch PV has been deleted.

#### Scenario: iSCSI cleanup after scratch-volume cutover
- **WHEN** Argo CD reconciles the democratic-csi chart after the former iSCSI PVC and PV are absent
- **THEN** the cluster MUST not retain the FreeNAS iSCSI CSI controller, node pods, or StorageClass

### Requirement: Static NFS CSI service remains available
The repository SHALL retain the `node-man` democratic-csi dependency for existing `org.democratic-csi.node-manual` PersistentVolumes.

#### Scenario: Static NFS volumes after iSCSI removal
- **WHEN** Argo CD reconciles the democratic-csi chart without `fn-iscsi`
- **THEN** the `node-man` controller and node pods MUST remain available for bound static NFS volumes

### Requirement: Argo CD does not include Helm-secrets integration
The repository SHALL not configure Argo CD to install, wrap, invoke, or decrypt Helm values through helm-secrets, SOPS, age, vals, curl, or the `helm-secrets-private-keys` Secret.

#### Scenario: Repo-server rendering after cleanup
- **WHEN** the Argo CD repo-server is rendered from the repository after cleanup
- **THEN** its pod specification MUST not contain Helm-secrets helper tooling, an age-key mount, or a custom Helm wrapper

#### Scenario: Bootstrap after cleanup
- **WHEN** the Argo CD bootstrap script is run after cleanup
- **THEN** it MUST not create `helm-secrets-private-keys`

### Requirement: Argo CD Helm-value encryption metadata is removed
The repository SHALL not retain the `secrets://values.sops.yaml` source reference, the dedicated Argo CD age recipient, or the SOPS creation rule for Kubernetes Helm `values.sops.yaml` files.

#### Scenario: Repository cleanup validation
- **WHEN** repository Kubernetes and SOPS configuration are searched after cleanup
- **THEN** they MUST contain no Helm-secrets reference, Argo CD age recipient, or Kubernetes `values.sops.yaml` rule
