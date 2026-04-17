# Verifies VM count scaling, naming conventions, resource sizing, and consistent domain assignment.

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

run "zero_tier_counts_create_no_vms" {
  command = plan
  variables {
    web_tier_count = 0
    app_tier_count = 0
    db_tier_count  = 0
  }
  assert {
    condition     = length(vsphere_virtual_machine.vm_web) == 0
    error_message = "No web VMs should be created when web_tier_count is 0"
  }
  assert {
    condition     = length(vsphere_virtual_machine.vm_app) == 0
    error_message = "No app VMs should be created when app_tier_count is 0"
  }
  assert {
    condition     = length(vsphere_virtual_machine.vm_db) == 0
    error_message = "No DB VMs should be created when db_tier_count is 0"
  }
}

run "web_vm_count_matches_variable" {
  command = plan
  variables {
    web_tier_count = 3
  }
  assert {
    condition     = length(vsphere_virtual_machine.vm_web) == 3
    error_message = "Number of web VMs must equal web_tier_count"
  }
}

run "app_vm_count_matches_variable" {
  command = plan
  variables {
    app_tier_count = 2
  }
  assert {
    condition     = length(vsphere_virtual_machine.vm_app) == 2
    error_message = "Number of app VMs must equal app_tier_count"
  }
}

run "db_vm_count_matches_variable" {
  command = plan
  variables {
    db_tier_count = 1
  }
  assert {
    condition     = length(vsphere_virtual_machine.vm_db) == 1
    error_message = "Number of DB VMs must equal db_tier_count"
  }
}

run "vm_names_include_tenant_name" {
  command = plan
  variables {
    web_tier_count  = 1
    app_tier_count  = 1
    db_tier_count   = 1
    aci_tenant_name = "myapp"
  }
  assert {
    condition     = vsphere_virtual_machine.vm_web[0].name == "myapp_terraform_web_0"
    error_message = "Web VM name must follow pattern <tenant>_terraform_web_<index>"
  }
  assert {
    condition     = vsphere_virtual_machine.vm_app[0].name == "myapp_terraform_app_0"
    error_message = "App VM name must follow pattern <tenant>_terraform_app_<index>"
  }
  assert {
    condition     = vsphere_virtual_machine.vm_db[0].name == "myapp_terraform_db_0"
    error_message = "DB VM name must follow pattern <tenant>_terraform_db_<index>"
  }
}

run "vm_cpu_comes_from_variable" {
  command = plan
  variables {
    web_tier_count = 1
    vsphere_vm_cpu = 4
  }
  assert {
    condition     = vsphere_virtual_machine.vm_web[0].num_cpus == 4
    error_message = "VM CPU count must match vsphere_vm_cpu variable"
  }
}

run "vm_memory_comes_from_variable" {
  command = plan
  variables {
    web_tier_count    = 1
    vsphere_vm_memory = 8192
  }
  assert {
    condition     = vsphere_virtual_machine.vm_web[0].memory == 8192
    error_message = "VM memory must match vsphere_vm_memory variable"
  }
}

run "all_tiers_use_consistent_vm_domain" {
  command = plan
  variables {
    web_tier_count = 1
    app_tier_count = 1
    db_tier_count  = 1
    vm_domain      = "corp.example.com"
  }
  assert {
    condition     = vsphere_virtual_machine.vm_web[0].clone[0].customize[0].linux_options[0].domain == "corp.example.com"
    error_message = "Web VM domain must match vm_domain variable"
  }
  assert {
    condition     = vsphere_virtual_machine.vm_app[0].clone[0].customize[0].linux_options[0].domain == "corp.example.com"
    error_message = "App VM domain must match vm_domain variable (was previously hardcoded to bsa.local.com)"
  }
  assert {
    condition     = vsphere_virtual_machine.vm_db[0].clone[0].customize[0].linux_options[0].domain == "corp.example.com"
    error_message = "DB VM domain must match vm_domain variable"
  }
}

run "vm_firmware_is_efi" {
  command = plan
  variables {
    web_tier_count = 1
  }
  assert {
    condition     = vsphere_virtual_machine.vm_web[0].firmware == "efi"
    error_message = "VM firmware must be set to efi"
  }
}
