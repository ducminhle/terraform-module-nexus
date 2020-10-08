resource "nexus_blobstore" "blobstores" {
  count = length(var.blobstores)

  name = lookup(element(var.blobstores, count.index), "name", null)
  type = lookup(element(var.blobstores, count.index), "type", "File")
  path = lookup(element(var.blobstores, count.index), "type", "File") == "File" ? lookup(element(var.blobstores, count.index), "path", null) : null

  dynamic "bucket_configuration" {
    for_each = lookup(element(var.blobstores, count.index), "bucket_configuration", null) == null ? [] : [lookup(element(var.blobstores, count.index), "bucket_configuration", null)]

    content {
      dynamic "bucket" {
        for_each = [bucket_configuration.value.bucket]
        content {
          name       = lookup(bucket.value, "name", null)
          region     = lookup(bucket.value, "region", null)
          prefix     = lookup(bucket.value, "prefix", null)
          expiration = lookup(bucket.value, "expiration", null)
        }
      }

      dynamic "bucket_security" {
        for_each = [bucket_configuration.value.bucket_security]
        content {
          access_key_id     = lookup(bucket_security.value, "access_key_id", null)
          secret_access_key = lookup(bucket_security.value, "secret_access_key", null)
          role              = lookup(bucket_security.value, "role", null)
          session_token     = lookup(bucket_security.value, "session_token", null)
        }
      }

      dynamic "encryption" {
        for_each = bucket_configuration.value.encryption == null ? [] : [bucket_configuration.value.encryption]
        content {
          encryption_key  = lookup(encryption.value, "encryption_key", null)
          encryption_type = lookup(encryption.value, "encryption_type", null)
        }
      }

      dynamic "advanced_bucket_connection" {
        for_each = bucket_configuration.value.advanced_bucket_connection == null ? [] : [bucket_configuration.value.advanced_bucket_connection]
        content {
          endpoint         = lookup(advanced_bucket_connection.value, "endpoint", null)
          force_path_style = lookup(advanced_bucket_connection.value, "force_path_style", null)
          signer_type      = lookup(advanced_bucket_connection.value, "signer_type", null)
        }
      }
    }
  }

  dynamic "soft_quota" {
    for_each = lookup(element(var.blobstores, count.index), "soft_quota", null) == null ? [] : [lookup(element(var.blobstores, count.index), "soft_quota", null)]
    content {
      limit = lookup(soft_quota.value, "limit", null)
      type  = lookup(soft_quota.value, "type", "spaceRemainingQuota")
    }
  }
}
