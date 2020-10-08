output "nexus_blobstores" {
  description = "List of helm blobstores"
  value       = nexus_blobstore.blobstores.*.name
}

output "helm_repos" {
  description = "List of helm repositories"
  value       = nexus_repository.helm_repo.*.name
}

output "docker_repos" {
  description = "List of docker repositories"
  value       = nexus_repository.docker_repos.*.name
}

output "docker_group" {
  description = "List of docker group"
  value       = nexus_repository.docker_group.*.name
}
