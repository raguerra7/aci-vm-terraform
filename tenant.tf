resource "aci_tenant" "tenant" {
  name        = var.aci_tenant_name
  description = "This tenant is created by terraform"
}

resource "aci_vrf" "test-vrf" {
  tenant_dn	= aci_tenant.tenant.id
  name 		= "test-vrf"
}

resource "aci_bridge_domain" "web_bd" {
  tenant_dn	= aci_tenant.tenant.id
  name		= "web_bd"
  relation_fv_rs_ctx = aci_vrf.test-vrf.id
}


resource "aci_subnet" "web_subnet" {
  parent_dn 	= aci_bridge_domain.web_bd.id
  ip 			= "10.10.1.1/24"
}

resource "aci_bridge_domain" "app_bd" {
  tenant_dn = aci_tenant.tenant.id
  name    = "app_bd"
  relation_fv_rs_ctx = aci_vrf.test-vrf.id
}


resource "aci_subnet" "app_subnet" {
  parent_dn   = aci_bridge_domain.app_bd.id
  ip      = "10.10.2.1/24"
}


resource "aci_bridge_domain" "db_bd" {
  tenant_dn = aci_tenant.tenant.id
  name    = "db_bd"
  relation_fv_rs_ctx = aci_vrf.test-vrf.id
}


resource "aci_subnet" "db_subnet" {
  parent_dn   = aci_bridge_domain.db_bd.id
  ip      = "10.10.3.1/16"
}


resource "aci_l3_outside" "internet" {
  tenant_dn = aci_tenant.tenant.id
  name      = "internet"
}

resource "aci_external_network_instance_profile" "dev_ext_net_prof" {
  l3_outside_dn = aci_l3_outside.internet.id
  name          = "ext_net_profile"
}

resource "aci_l3_ext_subnet" "ext_subnet" {
  external_network_instance_profile_dn = aci_external_network_instance_profile.dev_ext_net_prof.id
  ip          = "10.0.3.28/27"
}
