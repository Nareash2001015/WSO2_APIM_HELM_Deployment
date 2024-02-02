terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.88.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

module "random-pet" {
  source = "./random-pet"
  length = 1
}

module "local-file" {
  source   = "./local-file"
  content  = "My favourite pet is ${module.random-pet.pet-name}"
  filename = "./files/mypet.txt"
}

module "resource-group" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Resource-Group?ref=v0.5.0"
  resource_group_name = join("-", ["aks-deployment", "dev", "eastus"])
  location            = "EAST US"
  tags                = local.default_tags
}

module "virtual-network" {
  source                        = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Virtual-Network?ref=v0.5.0"
  virtual_network_name          = join("-", ["aks-deployment", "dev", "eastus", "vn"])
  resource_group_name           = module.resource-group.resource_group_name
  location                      = "EAST US"
  virtual_network_address_space = "10.0.0.0/16"
  depends_on                    = [module.resource-group]
  tags                          = local.default_tags
}

module "aks_cluster" {
  source                                               = "./AKS-Generic"
  aks_admin_username                                   = "wso2_user"
  aks_cluster_dns_prefix                               = "wso2apim"
  aks_cluster_name                                     = join("-", ["aks-deployment", "dev", "eastus", "aks"])
  aks_load_balancer_subnet_name                        = join("-", ["aks-load-balancer", "dev", "eastus", "sn"])
  aks_load_balancer_subnet_network_security_group_name = join("-", ["aks-load-balancer", "dev", "eastus", "nsg"])
  internal_loadbalancer_subnet_address_prefix          = "10.0.1.0/24"
  aks_node_pool_resource_group_name                    = module.resource-group.resource_group_name
  aks_node_pool_subnet_address_prefix                  = "10.0.2.0/24"
  aks_node_pool_subnet_name                            = join("-", ["aks-node-pool", "dev", "eastus", "sn"])
  aks_node_pool_subnet_network_security_group_name     = join("-", ["aks-node-pool", "dev", "eastus", "nsg"])
  aks_node_pool_subnet_route_table_name                = "wso2_route_table" # You may need to adjust this if it is coming from a different module
  aks_public_ssh_key_path                              = "~/.ssh/aks_rsa.pub"
  aks_resource_group_name                              = module.resource-group.resource_group_name
  azure_policy_enabled                                 = true
  default_node_pool_availability_zones                 = ["1", "2", "3"]
  default_node_pool_count                              = 4
  default_node_pool_max_count                          = 10
  default_node_pool_max_pods                           = 50
  default_node_pool_min_count                          = 4
  default_node_pool_name                               = "pool"
  default_node_pool_only_critical_addons_enabled       = true
  default_node_pool_orchestrator_version               = "1.27.7"
  default_node_pool_os_disk_type                       = "Ephemeral"
  default_node_pool_os_disk_size_gb                    = 128
  default_node_pool_vm_size                            = "Standard_D8ds_v5"
  service_cidr                                         = "10.0.3.0/24"
  dns_service_ip                                       = "10.0.3.3"
  docker_bridge_cidr                                   = "10.0.4.0/24"
  kubernetes_version                                   = "1.27.7"
  virtual_network_name                                 = module.virtual-network.virtual_network_name
  location                                             = "EAST US"
  virtual_network_resource_group_name                  = module.resource-group.resource_group_name
  aks_node_pool_subnet_routes = {
    route1 = {
      name                   = "Default"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.0.10.10"
    }
  }
  outbound_type = "loadBalancer"
}

# module "storage-account" {
#   source                   = "./azure-storage-account"
#   azure_disk_name          = join("", ["aks", "dev", "eastus", "storage"])
#   azure_disk_location      = "EAST US"
#   resource_group_name      = module.resource-group.resource_group_name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

