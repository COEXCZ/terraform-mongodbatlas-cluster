terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.8.2"
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

# Db instance #########################
resource "mongodbatlas_advanced_cluster" "cluster" {
  project_id                     = var.project_id
  name                           = replace(var.cluster_name, "_", "-")
  cluster_type                   = var.cluster_type
  termination_protection_enabled = var.cluster_termination_protection_enabled
  disk_size_gb = var.disk_size_gb
  mongo_db_major_version = var.mongo_db_major_version
  backup_enabled = var.backup_enabled

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

# Backuping scheduler #####################
# requires to have IP access list created on API KEY, update via web UI
resource "mongodbatlas_cloud_backup_schedule" "backup_schedule" {
  count = var.backup_enabled == true ? 0 : 1

  project_id                     = var.project_id
  cluster_name = replace(var.cluster_name, "_", "-")

  reference_hour_of_day    = var.backup_hour
  reference_minute_of_hour = var.backup_minute


  // This will now add the desired policy items to the existing mongodbatlas_cloud_backup_schedule resource

  policy_item_daily {
    frequency_interval = 1
    retention_unit     = "days"
    retention_value    = var.backup_retention_days
  }
}
