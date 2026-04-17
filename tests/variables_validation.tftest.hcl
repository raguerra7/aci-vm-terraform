# Verifies that variable validation blocks reject out-of-range inputs.

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

run "reject_empty_tenant_name" {
  command = plan
  variables {
    aci_tenant_name = ""
  }
  expect_failures = [var.aci_tenant_name]
}

run "reject_negative_web_tier_count" {
  command = plan
  variables {
    web_tier_count = -1
  }
  expect_failures = [var.web_tier_count]
}

run "reject_negative_app_tier_count" {
  command = plan
  variables {
    app_tier_count = -1
  }
  expect_failures = [var.app_tier_count]
}

run "reject_negative_db_tier_count" {
  command = plan
  variables {
    db_tier_count = -1
  }
  expect_failures = [var.db_tier_count]
}

run "reject_zero_cpu" {
  command = plan
  variables {
    vsphere_vm_cpu = 0
  }
  expect_failures = [var.vsphere_vm_cpu]
}

run "reject_insufficient_memory" {
  command = plan
  variables {
    vsphere_vm_memory = 256
  }
  expect_failures = [var.vsphere_vm_memory]
}

run "reject_zero_disksize" {
  command = plan
  variables {
    vsphere_vm_disksize = 0
  }
  expect_failures = [var.vsphere_vm_disksize]
}

run "reject_zero_timeout" {
  command = plan
  variables {
    timeout = 0
  }
  expect_failures = [var.timeout]
}

run "accept_valid_defaults" {
  command = plan
  assert {
    condition     = var.web_tier_count == 0
    error_message = "Default web_tier_count should be 0"
  }
  assert {
    condition     = var.vsphere_vm_cpu == 2
    error_message = "Default vsphere_vm_cpu should be 2"
  }
  assert {
    condition     = var.vsphere_vm_memory == 2048
    error_message = "Default vsphere_vm_memory should be 2048"
  }
}
