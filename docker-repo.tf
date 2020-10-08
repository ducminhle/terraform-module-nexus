resource "nexus_repository" "docker_group" {
  count = length(var.docker_repos) > 0 && var.docker_group_repos != null ? 1 : 0
  name   = lookup(var.docker_group_repos, "name", null)
  format = "docker"
  type   = "group"

  group {
    member_names = concat([
      for repo in nexus_repository.docker_repos : repo.name
    ])
  }

  docker {
    force_basic_auth = lookup(var.docker_group_repos, "force_basic_auth", false)
    v1enabled        = lookup(var.docker_group_repos, "v1enabled", true)
    http_port        = lookup(var.docker_group_repos, "http_port", 8082)
    https_port       = lookup(var.docker_group_repos, "https_port", null)
  }

  proxy {
    remote_url       = lookup(var.docker_group_repos, "proxy_remote_url", null)
    content_max_age  = lookup(var.docker_group_repos, "proxy_content_max_age", null)
    metadata_max_age = lookup(var.docker_group_repos, "proxy_metadata_max_age", null)
  }

  storage {
    blob_store_name                = lookup(var.docker_group_repos, "storage_blob_store_name", "default")
    strict_content_type_validation = lookup(var.docker_group_repos, "storage_strict_content_type_validation", null)
    write_policy                   = lookup(var.docker_group_repos, "storage_write_policy", null)
  }
}

resource "nexus_repository" "docker_repos" {
  count = length(var.docker_repos)

  name   = lookup(element(var.docker_repos, count.index), "name", null)
  format = "docker"
  type   = lookup(element(var.docker_repos, count.index), "type", "proxy")

  docker {
    force_basic_auth = lookup(element(var.docker_repos, count.index), "force_basic_auth", false)
    v1enabled        = lookup(element(var.docker_repos, count.index), "v1enabled", true)
    http_port        = lookup(element(var.docker_repos, count.index), "http_port", null)
    https_port       = lookup(element(var.docker_repos, count.index), "https_port", null)
  }

  dynamic "docker_proxy" {
    for_each = lookup(element(var.docker_repos, count.index), "docker_proxy_index_url", null) == null && lookup(element(var.docker_repos, count.index), "docker_proxy_index_type", null) == null ? [] : [
      {
        index_url  = lookup(element(var.docker_repos, count.index), "docker_proxy_index_url", null)
        index_type = lookup(element(var.docker_repos, count.index), "docker_proxy_index_type", null)
      }
    ]
    content {
      index_url  = docker_proxy.value.index_url
      index_type = docker_proxy.value.index_type
    }
  }

  proxy {
    remote_url       = lookup(element(var.docker_repos, count.index), "proxy_remote_url", null)
    content_max_age  = lookup(element(var.docker_repos, count.index), "proxy_content_max_age", null)
    metadata_max_age = lookup(element(var.docker_repos, count.index), "proxy_metadata_max_age", null)
  }

  storage {
    blob_store_name                = lookup(element(var.docker_repos, count.index), "storage_blob_store_name", "default")
    strict_content_type_validation = lookup(element(var.docker_repos, count.index), "storage_strict_content_type_validation", null)
    write_policy                   = lookup(element(var.docker_repos, count.index), "storage_write_policy", null)
  }

  negative_cache {
    enabled = lookup(element(var.docker_repos, count.index), "negative_cache_enabled", null)
    ttl     = lookup(element(var.docker_repos, count.index), "negative_cache_ttl", null)
  }

  http_client {
    # now crash with nexus provider 1.10.2
    blocked    = lookup(element(var.docker_repos, count.index), "http_client_blocked", false)
    auto_block = lookup(element(var.docker_repos, count.index), "http_client_auto_block", true)

    authentication {
      type        = lookup(element(var.docker_repos, count.index), "http_client_type", null)
      username    = lookup(element(var.docker_repos, count.index), "http_client_username", null)
      password    = lookup(element(var.docker_repos, count.index), "http_client_password", null)
      ntlm_domain = lookup(element(var.docker_repos, count.index), "http_client_ntlm_domain", null)
      ntlm_host   = lookup(element(var.docker_repos, count.index), "http_client_ntlm_host", null)
    }
  }

  cleanup {
    policy_names = lookup(element(var.docker_repos, count.index), "cleanup_policy_names", [])
  }
}
