## 1. Remove Obsolete Manifests

- [x] 1.1 Delete the unused NetBox Helm application directory, including its four SealedSecret manifests.
- [x] 1.2 Delete the stale NetBox rule from the Argo CD Image Updater template.
- [x] 1.3 Delete the sealed-secrets infrastructure Helm application directory.
- [x] 1.4 Delete the obsolete Kustomize name-reference configuration and remove it from the base Kustomization.

## 2. Validate Cleanup

- [x] 2.1 Verify repository manifests contain no NetBox application, `SealedSecret` kind, or sealed-secrets controller reference.
- [x] 2.2 Render or validate the affected Kubernetes configuration and run repository formatting or diff checks applicable to the removed files.
- [x] 2.3 After Argo CD reconciliation, verify the NetBox and sealed-secrets Applications and resources are absent while Infisical resources remain healthy.
