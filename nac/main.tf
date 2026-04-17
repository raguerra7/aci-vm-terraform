module "aci" {
  source  = "netascode/nac-aci/aci"
  version = ">= 0.8.0"

  yaml_directories = ["${path.module}/data/"]

  manage_access_policies = var.manage_access_policies
  manage_tenants         = var.manage_tenants
}
