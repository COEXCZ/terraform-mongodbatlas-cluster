terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.6.0"
    }
  }
}

# db users ############################
resource "mongodbatlas_database_user" "users" {
  for_each = {for index, u in var.users :  index => u}

  username           = "${each.value.username}"
  password           = each.value.password
  project_id         = var.project_id
  auth_database_name = "admin"

  roles {
    role_name     = "${each.value.role_name}"
    database_name = "${each.value.database}"
  }

  scopes {
    name = mongodbatlas_advanced_cluster.cluster.name
    type = "CLUSTER"
  }
}

# FW #########################
resource "mongodbatlas_project_ip_access_list" "cluster_access_ip" {
  for_each = {for ip in var.allowed_ips :  ip.ip_address => ip}

  project_id = var.project_id
  ip_address = each.value.ip_address
  comment    = each.value.comment ? each.value.comment : ""
}

# Db instance #########################
resource "mongodbatlas_advanced_cluster" "cluster" {
  project_id                     = var.project_id
  name                           = replace(var.cluster_name, "_", "-")
  cluster_type                   = var.cluster_type
  termination_protection_enabled = var.cluster_termination_protection_enabled
  disk_size_gb = var.disk_size_gb

  replication_specs {
    region_configs {
      electable_specs {
        instance_size = var.cluster_electable_specs_instance_size
        node_count    = var.cluster_electable_specs_node_count
        disk_iops     = var.cluster_electable_specs_disk_iops
      }
      provider_name         = var.cluster_region_configs_provider_name
      backing_provider_name = var.cluster_region_configs_backing_provider_name
      region_name           = var.cluster_region_configs_region_name
      priority              = var.cluster_region_configs_priority
    }
    num_shards = var.cluster_replication_specs_num_shards
  }
}
