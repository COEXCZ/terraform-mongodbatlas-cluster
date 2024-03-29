variable "project_id" {
  description = "Project ID"
  type        = any
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "cluster_type" {
  description = "Cluster type"
  type        = string
  default     = "REPLICASET"
}

variable "cluster_termination_protection_enabled" {
  description = "Cluster termination protection"
  type        = bool
  default     = false
}

variable "cluster_electable_specs_instance_size" {
  description = "Size of Mongodb instance"
  type        = string
}

variable "cluster_electable_specs_node_count" {
  description = "Number of deployed nodes"
  type        = number
  default     = 3
}

variable "cluster_electable_specs_disk_iops" {
  description = "Reserved IOPs"
  type        = number
  default     = 0
}

# https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/advanced_cluster#region_configs
variable "cluster_region_configs_provider_name" {
  description = "Provider name"
  type        = string
  default     = "TENANT"
}

variable "cluster_region_configs_backing_provider_name" {
  description = "Backing provider name"
  type        = string
  default     = "AWS"
}

variable "cluster_region_configs_region_name" {
  description = "Region of deployment"
  type        = string
}

variable "cluster_region_configs_priority" {
  description = "Deployment priority https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/advanced_cluster#priority"
  type        = number
  default     = 7
}

# https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/advanced_cluster#num_shards
variable "cluster_replication_specs_num_shards" {
  description = "Provide this value if you set a cluster_type of SHARDED or GEOSHARDED."
  type        = number
  default     = 1
}

variable "users" {
  description = "List of database resource configs"
  type        = list(any)
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "project_name" {
  description = "Project name to construct correct naming convention names"
  type        = string
}

variable "disk_size_gb" {
  description = "Storage size for cluster node"
  type = number
  default = null
}

variable "mongo_db_major_version" {
  description = "Major version for mongodb"
  type = number
  default = 5.0
}

variable "backup_enabled" {
  description = "Set to true to enable Atlas legacy backups for the cluster"
  type = bool
}

variable "backup_hour" {
  description = "UTC Hour of day between 0 and 23, inclusive"
  type = number
  default = 0
}

variable "backup_minute" {
  description = "UTC Minutes after reference_hour_of_day that Atlas takes snapshots for backup policy items. Must be between 0 and 59, inclusive."
  type = number
  default = 0
}

variable "backup_retention_days" {
  description = "UTC Minutes after reference_hour_of_day that Atlas takes snapshots for backup policy items. Must be between 0 and 59, inclusive."
  type = number
  default = 0
}
