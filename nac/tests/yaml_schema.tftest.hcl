# Validates that the YAML data files are well-formed and the module accepts them
# without errors. Uses mock providers so no live APIC is required.
#
# Run with: terraform test
#
# These tests exercise the NaC module's YAML parsing and data-model merging logic.
# They catch typos, missing required fields, and structural errors in the YAML files
# before any changes reach a real fabric.

mock_provider "aci" {}

mock_provider "utils" {
  alias = "utils"
}

mock_provider "local" {}

run "yaml_files_load_without_errors" {
  command = plan

  assert {
    condition     = module.aci.model != null
    error_message = "NaC module must produce a non-null model from the YAML files"
  }
}

run "tenant_3tier_app_is_present_in_model" {
  command = plan

  assert {
    condition     = contains(keys(module.aci.model.apic.tenants), "3tier-app")
    error_message = "Model must contain the '3tier-app' tenant defined in tenant_3tier_app.yaml"
  }
}

run "access_policies_vlan_pool_is_present_in_model" {
  command = plan

  assert {
    condition     = contains(
      keys(module.aci.model.apic.access_policies.vlan_pools),
      "vmware-vlan-pool"
    )
    error_message = "Model must contain the 'vmware-vlan-pool' defined in access_policies.yaml"
  }
}

run "vmm_domain_is_present_in_model" {
  command = plan

  assert {
    condition     = contains(
      keys(module.aci.model.apic.access_policies.vmware_vmm_domains),
      "vDS-Comp-01"
    )
    error_message = "Model must contain the 'vDS-Comp-01' VMM domain defined in access_policies.yaml"
  }
}
