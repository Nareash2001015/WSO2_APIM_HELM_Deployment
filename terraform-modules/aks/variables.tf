variable "name"{
    type = string
}

variable "location"{
    type = string
}

variable "resource_group_name"{
    type = string
}

variable "dns_prefix"{
    type = string
}

variable "default_node_pool_name"{
    type = string
}

variable "default_node_pool_node_count"{
    type = number
}

variable "default_node_pool_vm_size"{
    type = string
}

variable "identity_type"{
    type = string
}

variable "tags_environment"{
    type = string
}
