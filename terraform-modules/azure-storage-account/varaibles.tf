variable "azure_disk_name" {
  type        = string
  description = "Name for the azure managed disk"
}

variable "azure_disk_location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "account_tier" {
  type = string
}

variable "account_replication_type" {
  type = string
}