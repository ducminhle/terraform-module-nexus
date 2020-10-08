variable "nexus_url" {
  description = "Nexus URL to access"
}

variable "nexus_insecure" {
  description = "Nexus skip verify"
  default     = true
}

variable "nexus_username" {
  description = "Nexus username to access"
  default     = "admin"
}

variable "nexus_password" {
  description = "Nexus password to access"
  default     = ""
}

variable "blobstores" {
  description = "List blobstores need to create"
  type        = list(any)
  default     = []
}

variable "helm_repos" {
  description = "Helm repos need to create"
  type        = list(any)
  default     = []
}

variable "docker_repos" {
  description = "Docker repos need to create"
  type        = any
  default     = []
}

variable "docker_proxy_repos" {
  description = "Docker proxy repos need to create"
  type        = any
  default     = []
}

variable "docker_group_repos" {
  description = "Docker group repos need to create"
  type        = any
  default     = null
}
