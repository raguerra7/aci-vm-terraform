terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    }
    aci = {
      source = "ciscodevnet/aci"
    }
  
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # if you have a self-signed cert
  allow_unverified_ssl = true
}
provider "aci" {
    # cisco-aci user name
    username = var.aci_username
    # cisco-aci password
    password = var.aci_password
    # cisco-aci url
    url      = var.aci_url
    insecure = true
}
