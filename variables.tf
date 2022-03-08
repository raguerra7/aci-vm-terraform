variable "aci_tenant_name" {
  description = "describe your variable"
  default = "WAR-TF"
}

variable aci_username {
  default = "admin"
}

variable aci_password {
  default = "Brasilia#2021"
  sensitive = true
}

variable aci_url {
  default = "https://10.0.1.151"
}

variable "vsphere_user" {
  default = "administrator@vsphere.local"
  description = "the username for vsphere"
}
variable "vsphere_password" {
  default = "Brasilia#2021"
  description = "The password for vsphere"
  sensitive = true
}
variable "vsphere_server" {
  default = "dc-vcsa.bsa.local"
  description = "the hostname or ip address of your vcenter server"
}

variable "vsphere_datacenter" {
  type = string
  description = "the name of the datacenter"
  default = "Compute"
}

variable "vsphere_datastore" {
  type = string
  description = "the name of the datastore"
  default = "DS-HX"
}

variable "vsphere_vm_template" {
  type = string
  description = "the name of the vm template"
  default = "TEMPLATE_VM_RHE"
}

variable "vsphere_vm_name" {
  type = string
  description = "the name of the vm"
  default = "Teste"
}

variable "vsphere_resource_pool" {
  type = string
  description = "the name of the resourcepool for examples: Cluster1/Resources"
  default = "TF-WAR-VMs"

}

variable "vsphere_vm_cpu" {
  type = number
  description = "the number of vCpus "
  default = 2
}

variable "vsphere_vm_memory" {
  type = number
  description = "the amount of memory in MB"
  default = 2048
}

variable "vsphere_vm_guest" {
  type = string
  description = "the name of the os type "
  default = "centos64Guest"
}

variable "vsphere_vm_disksize" {
  type = number
  description = "the size of the disk in GB"
  default = 20
}

variable "timeout" {
  description = "The timeout, in minutes, to wait for the virtual machine clone to complete."
  type        = number
  default     = 30
}

variable "linked_clone" {
  description = "Clone this virtual machine from a snapshot. Templates must have a single snapshot only in order to be eligible."
  default     = false
}

variable "web_tier_count" {
  description = "how many VM are deployed in Web Tier"
  default = 0
}

variable "app_tier_count" {
  description = "how many VM are deployed in Web Tier"
  default = 0
}

variable "db_tier_count" {
  description = "how many VM are deployed in Web Tier"
  default = 0
}