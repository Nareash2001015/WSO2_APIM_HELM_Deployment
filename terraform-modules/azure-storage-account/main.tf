resource "azurerm_storage_account" "azure-storage-account" {
  name                 = "${var.azure_disk_name}"
  location             = "${var.azure_disk_location}"
  resource_group_name  = "${var.resource_group_name}"
  account_tier =  "${var.account_tier}"
  account_replication_type = "${var.account_replication_type}"
}