resource "nexus_repository" "helm_repo" {
  count = length(var.helm_repos)

  name   = lookup(element(var.helm_repos, count.index), "name", null)
  format = "helm"
  type   = lookup(element(var.helm_repos, count.index), "type", "proxy")

  proxy {
    remote_url       = lookup(element(var.helm_repos, count.index), "proxy_remote_url", null)
    content_max_age  = lookup(element(var.helm_repos, count.index), "proxy_content_max_age", null)
    metadata_max_age = lookup(element(var.helm_repos, count.index), "proxy_metadata_max_age", null)
  }

  storage {
    blob_store_name                = lookup(element(var.helm_repos, count.index), "storage_blob_store_name", "default")
    strict_content_type_validation = lookup(element(var.helm_repos, count.index), "storage_strict_content_type_validation", null)
    write_policy                   = lookup(element(var.helm_repos, count.index), "storage_write_policy", null)
  }

  negative_cache {
    enabled = lookup(element(var.helm_repos, count.index), "negative_cache_enabled", null)
    ttl     = lookup(element(var.helm_repos, count.index), "negative_cache_ttl", null)
  }

  http_client {
    # now crash with nexus provider 1.10.2
    # blocked = lookup(element(var.helm_repos, count.index), "http_client_blocked", false)
    # auto_block = lookup(element(var.helm_repos, count.index), "http_client_auto_block", true)

    # authentication {
    #   type = lookup(element(var.helm_repos, count.index), "http_client_type", null)
    #   username = lookup(element(var.helm_repos, count.index), "http_client_username", null)
    #   password = lookup(element(var.helm_repos, count.index), "http_client_password", null)
    #   ntlm_domain = lookup(element(var.helm_repos, count.index), "http_client_ntlm_domain", null)
    #   ntlm_host = lookup(element(var.helm_repos, count.index), "http_client_ntlm_host", null)
    # }
  }

  # cleanup {
  #   policy_names = lookup(element(var.helm_repos, count.index), "cleanup_policy_names", [])
  # }
}
