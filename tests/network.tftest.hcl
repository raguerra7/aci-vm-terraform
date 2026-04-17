# Verifies ACI tenant, VRF, bridge domains, application profile, EPGs, and domain assignments.

mock_provider "vsphere" {}
mock_provider "aci" {}
mock_provider "time" {}

variables {
  vsphere_user          = "testuser"
  vsphere_password      = "testpass"
  vsphere_server        = "vcenter.test.local"
  vsphere_datacenter    = "TestDC"
  vsphere_datastore     = "TestDS"
  vsphere_vm_template   = "rhel8-template"
  vsphere_vm_name       = "test-vm"
  vsphere_resource_pool = "TestCluster/Resources"
  vsphere_vm_portgroup  = "test-portgroup"
  aci_tenant_name       = "test-tenant"
}

run "tenant_name_comes_from_variable" {
  command = plan
  assert {
    condition     = aci_tenant.tenant.name == "test-tenant"
    error_message = "Tenant name must match aci_tenant_name variable"
  }
}

run "three_bridge_domains_are_created" {
  command = plan
  assert {
    condition     = aci_bridge_domain.web_bd.name == "web_bd"
    error_message = "web_bd bridge domain must be created"
  }
  assert {
    condition     = aci_bridge_domain.app_bd.name == "app_bd"
    error_message = "app_bd bridge domain must be created"
  }
  assert {
    condition     = aci_bridge_domain.db_bd.name == "db_bd"
    error_message = "db_bd bridge domain must be created"
  }
}

run "three_epgs_are_created" {
  command = plan
  assert {
    condition     = aci_application_epg.WEB_EPG.name == "WEB_EPG"
    error_message = "WEB_EPG must be created with correct name"
  }
  assert {
    condition     = aci_application_epg.APP_EPG.name == "APP_EPG"
    error_message = "APP_EPG must be created with correct name"
  }
  assert {
    condition     = aci_application_epg.DB_EPG.name == "DB_EPG"
    error_message = "DB_EPG must be created with correct name"
  }
}

run "all_epgs_use_vmm_domain_dn_variable" {
  command = plan
  variables {
    vmm_domain_dn = "uni/vmmp-VMware/dom-custom-vds"
  }
  assert {
    condition     = aci_epg_to_domain.web.tdn == "uni/vmmp-VMware/dom-custom-vds"
    error_message = "WEB EPG domain association must use vmm_domain_dn variable"
  }
  assert {
    condition     = aci_epg_to_domain.app.tdn == "uni/vmmp-VMware/dom-custom-vds"
    error_message = "APP EPG domain association must use vmm_domain_dn variable"
  }
  assert {
    condition     = aci_epg_to_domain.db.tdn == "uni/vmmp-VMware/dom-custom-vds"
    error_message = "DB EPG domain association must use vmm_domain_dn variable"
  }
}

run "default_vmm_domain_dn_is_set" {
  command = plan
  assert {
    condition     = var.vmm_domain_dn == "uni/vmmp-VMware/dom-vDS-Comp-01"
    error_message = "Default vmm_domain_dn must be uni/vmmp-VMware/dom-vDS-Comp-01"
  }
}

run "application_profile_name_is_test_app" {
  command = plan
  assert {
    condition     = aci_application_profile.test-app.name == "test-app"
    error_message = "Application profile name must be test-app"
  }
}
