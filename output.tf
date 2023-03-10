# outputs ####################
output "project_id" {
  value = var.project_id
}

output "cluster_id" {
  value = mongodbatlas_advanced_cluster.cluster.id
}

output "cluster_connection_strings" {
  value = mongodbatlas_advanced_cluster.cluster.connection_strings
}

output "cluster_name" {
  value = mongodbatlas_advanced_cluster.cluster.name
}

output "cluster_cluser_id" {
  value = mongodbatlas_advanced_cluster.cluster.cluster_id
}

output "cluster_users" {
  value = {for index, u in mongodbatlas_database_user.users : index => {
    username: u.username,
    password: nonsensitive(u.password),
    roles: u.roles
  }}
}
