variable "aci_tenant_name" {
  type        = string
  description = "Name of the ACI tenant to create"
  default     = ""
  validation {
    condition     = length(trimspace(var.aci_tenant_name)) > 0
    error_message = "aci_tenant_name must not be empty."
  }
}

variable "aci_username" {
  type        = string
  description = "Username for ACI APIC authentication"
  default     = ""
}

variable "aci_password" {
  type        = string
  description = "Password for ACI APIC authentication"
  default     = ""
  sensitive   = true
}

variable "aci_url" {
  type        = string
  description = "URL of the ACI APIC controller (e.g. https://apic.example.com)"
  default     = ""
}

variable "vsphere_user" {
  type        = string
  description = "Username for vSphere authentication"
}

variable "vsphere_password" {
  type        = string
  description = "Password for vSphere authentication"
  sensitive   = true
}

variable "vsphere_server" {
  type        = string
  description = "Hostname or IP address of the vCenter server"
}

variable "vsphere_datacenter" {
  type        = string
  description = "Name of the vSphere datacenter"
}

variable "vsphere_datastore" {
  type        = string
  description = "Name of the vSphere datastore"
}

variable "vsphere_vm_template" {
  type        = string
  description = "Name of the VM template to clone"
}

variable "vsphere_vm_name" {
  type        = string
  description = "Base name for VMs (tier and index are appended automatically)"
}

variable "vsphere_resource_pool" {
  type        = string
  description = "Resource pool path, e.g. Cluster1/Resources"
}

variable "vsphere_vm_portgroup" {
  type        = string
  description = "Name of the default portgroup"
}

variable "vsphere_vm_cpu" {
  type        = number
  description = "Number of vCPUs per VM"
  default     = 2
  validation {
    condition     = var.vsphere_vm_cpu >= 1
    error_message = "vsphere_vm_cpu must be at least 1."
  }
}

variable "vsphere_vm_memory" {
  type        = number
  description = "Amount of memory per VM in MB"
  default     = 2048
  validation {
    condition     = var.vsphere_vm_memory >= 512
    error_message = "vsphere_vm_memory must be at least 512 MB."
  }
}

variable "vsphere_vm_guest" {
  type        = string
  description = "vSphere guest OS identifier"
  default     = "rhel8_64Guest"
}

variable "vsphere_vm_disksize" {
  type        = number
  description = "Disk size per VM in GB"
  default     = 20
  validation {
    condition     = var.vsphere_vm_disksize >= 1
    error_message = "vsphere_vm_disksize must be at least 1 GB."
  }
}

variable "timeout" {
  type        = number
  description = "Timeout in minutes for VM clone operations"
  default     = 30
  validation {
    condition     = var.timeout > 0
    error_message = "timeout must be a positive number of minutes."
  }
}

variable "linked_clone" {
  type        = bool
  description = "Clone VMs from a snapshot. Template must have exactly one snapshot."
  default     = false
}

variable "web_tier_count" {
  type        = number
  description = "Number of VMs to deploy in the Web Tier"
  default     = 0
  validation {
    condition     = var.web_tier_count >= 0
    error_message = "web_tier_count must be a non-negative integer."
  }
}

variable "app_tier_count" {
  type        = number
  description = "Number of VMs to deploy in the App Tier"
  default     = 0
  validation {
    condition     = var.app_tier_count >= 0
    error_message = "app_tier_count must be a non-negative integer."
  }
}

variable "db_tier_count" {
  type        = number
  description = "Number of VMs to deploy in the DB Tier"
  default     = 0
  validation {
    condition     = var.db_tier_count >= 0
    error_message = "db_tier_count must be a non-negative integer."
  }
}

variable "dns_list" {
  type        = string
  description = "DNS server IP address"
  default     = ""
}

variable "dns_search" {
  type        = string
  description = "DNS search domain"
  default     = ""
}

variable "vmm_domain_dn" {
  type        = string
  description = "Distinguished name of the VMware VMM domain, e.g. uni/vmmp-VMware/dom-vDS-Comp-01"
  default     = "uni/vmmp-VMware/dom-vDS-Comp-01"
}

variable "vm_domain" {
  type        = string
  description = "DNS domain suffix for VM hostnames"
  default     = "bsa.local"
}
