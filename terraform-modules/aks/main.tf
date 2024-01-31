resource "azurerm_kubernetes_cluster" "aks-cluster-apim" {
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "${var.dns_prefix}"

  default_node_pool {
    name       = "${var.default_node_pool_name}"
    node_count = "${var.default_node_pool_node_count}"
    vm_size    = "${var.default_node_pool_vm_size}"
  }

  identity {
    type = "${var.identity_type}"
  }

  tags = {
    Environment = "${var.tags_environment}"
  }
}