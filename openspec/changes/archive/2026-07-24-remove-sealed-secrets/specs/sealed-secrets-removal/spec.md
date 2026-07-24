## ADDED Requirements

### Requirement: Repository excludes unused NetBox resources
The repository SHALL not declare the unused NetBox Helm application, its sealed credential manifests, or Image Updater configuration.

#### Scenario: Application discovery after cleanup
- **WHEN** Argo CD evaluates the application ApplicationSet after the cleanup
- **THEN** it MUST not discover a `netbox` application from the repository

#### Scenario: Image updater configuration after cleanup
- **WHEN** the Argo CD Image Updater template is rendered after the cleanup
- **THEN** it MUST not contain a NetBox image rule

### Requirement: Repository excludes sealed-secrets infrastructure
The repository SHALL not declare the Bitnami sealed-secrets controller, its namespace, or any `SealedSecret` resource.

#### Scenario: Kubernetes manifest validation after cleanup
- **WHEN** the repository Kubernetes manifests are rendered or searched after the cleanup
- **THEN** they MUST contain no `SealedSecret` kind or sealed-secrets controller declaration

### Requirement: Existing Infisical management remains unchanged
The cleanup SHALL not add, remove, or modify Infisical operator configuration, Infisical authentication resources, or Infisical static-secret resources.

#### Scenario: Infisical reconciliation after cleanup
- **WHEN** Argo CD reconciles the cleanup
- **THEN** existing Infisical-managed workload secrets MUST remain managed by their existing Infisical resources
