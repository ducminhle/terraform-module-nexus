# terraform-module-nexus

## Description

- Create Blobstore
- Create Docker repos (hosted and proxy)
- Create Helm repos (hosted and proxy)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| nexus | 1.10.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| blobstores | List blobstores need to create | `list(any)` | `[]` | no |
| docker\_group\_repos | Docker group repos need to create | `any` | `null` | no |
| docker\_proxy\_repos | Docker proxy repos need to create | `list(any)` | `[]` | no |
| docker\_repos | Docker repos need to create | `list(any)` | `[]` | no |
| helm\_repos | Helm repos need to create | `list(any)` | `[]` | no |
| nexus\_insecure | Nexus skip verify | `bool` | `true` | no |
| nexus\_password | Nexus password to access | `string` | `""` | no |
| nexus\_url | Nexus URL to access | `any` | n/a | yes |
| nexus\_username | Nexus username to access | `string` | `"admin"` | no |

## Outputs

| Name | Description |
|------|-------------|
| docker\_group | List of docker group |
| docker\_repos | List of docker repositories |
| helm\_repos | List of helm repositories |
| nexus\_blobstores | List of helm blobstores |

## Example

### Terragrunt

terragrunt.hcl

``` hcl
terraform {
  source = "github.com/ducminhle/terraform-module-nexus"
}

inputs = merge(
  yamldecode(
    file("${get_terragrunt_dir()}/values.yml"),
  ),
)
```

values.yml
``` yaml
nexus_url: http://127.0.0.1:8081
nexus_insecure: true
nexus_username: admin
nexus_password: admin

blobstores:
  - name: test
    type: File
    path: "/nexus-data/blobs/test"
    soft_quota:
      limit: 200000000
      type: spaceRemainingQuota

helm_repos:
  - name: binami
    type: proxy
    proxy_remote_url: https://charts.bitnami.com/bitnami
    proxy_content_max_age: 86400
    proxy_metadata_max_age: 86400
    storage_blob_store_name: default
    storage_strict_content_type_validation: true
    storage_write_policy: ALLOW
    negative_cache_enabled: true
    negative_cache_ttl: 86400

docker_repos:
  - name: dockerhub
    type: proxy
    docker_proxy_index_url: https://registry-1.docker.io
    docker_proxy_index_type: HUB
    http_port: 8090
    proxy_remote_url: https://registry-1.docker.io
    proxy_content_max_age: 86400
    proxy_metadata_max_age: 86400
    storage_blob_store_name: default
    storage_strict_content_type_validation: true
    storage_write_policy: ALLOW
    negative_cache_enabled: true
    negative_cache_ttl: 86400
  - name: test
    type: hosted
    http_port: 8082
    storage_blob_store_name: default
    storage_strict_content_type_validation: true
    storage_write_policy: ALLOW
    negative_cache_enabled: true
    storage_blob_store_name: test
    negative_cache_ttl: 86400

docker_group_repos:
  name: docker_groups
  http_port: 8083
  storage_blob_store_name: default
  storage_strict_content_type_validation: true
  storage_write_policy: ALLOW
```
