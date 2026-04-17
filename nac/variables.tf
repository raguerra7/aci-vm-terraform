variable "aci_username" {
  type        = string
  description = "ACI APIC username"
}

variable "aci_password" {
  type        = string
  description = "ACI APIC password"
  sensitive   = true
}

variable "aci_url" {
  type        = string
  description = "ACI APIC URL, e.g. https://apic.example.com"
  validation {
    condition     = startswith(var.aci_url, "https://")
    error_message = "aci_url must begin with https://"
  }
}

variable "aci_insecure" {
  type        = bool
  description = "Skip TLS certificate verification (set true only in lab environments)"
  default     = false
}

variable "manage_access_policies" {
  type        = bool
  description = "Deploy access policies: VLAN pools, VMM domains, AEPs, interface policies"
  default     = true
}

variable "manage_tenants" {
  type        = bool
  description = "Deploy tenant configurations: VRFs, bridge domains, EPGs, contracts"
  default     = true
}
