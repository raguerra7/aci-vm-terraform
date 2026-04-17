# Verifies ACI contract definitions, filter port assignments, and EPG consumer/provider roles.

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

run "http_filter_entry_port_is_80" {
  command = plan
  assert {
    condition     = aci_filter_entry.http.d_from_port == "80"
    error_message = "HTTP filter entry d_from_port must be 80"
  }
  assert {
    condition     = aci_filter_entry.http.d_to_port == "80"
    error_message = "HTTP filter entry d_to_port must be 80"
  }
  assert {
    condition     = aci_filter_entry.http.prot == "tcp"
    error_message = "HTTP filter entry must use TCP protocol"
  }
}

run "mysql_filter_entry_port_is_3306" {
  command = plan
  assert {
    condition     = aci_filter_entry.mysql.d_from_port == "3306"
    error_message = "MySQL filter entry d_from_port must be 3306"
  }
  assert {
    condition     = aci_filter_entry.mysql.d_to_port == "3306"
    error_message = "MySQL filter entry d_to_port must be 3306"
  }
  assert {
    condition     = aci_filter_entry.mysql.prot == "tcp"
    error_message = "MySQL filter entry must use TCP protocol"
  }
}

run "tomcat_filter_entry_port_range_is_8080_to_8081" {
  command = plan
  assert {
    condition     = aci_filter_entry.tomcat.d_from_port == "8080"
    error_message = "Tomcat filter entry d_from_port must be 8080"
  }
  assert {
    condition     = aci_filter_entry.tomcat.d_to_port == "8081"
    error_message = "Tomcat filter entry d_to_port must be 8081"
  }
}

run "app_to_web_consumer_is_web_epg" {
  command = plan
  assert {
    condition     = aci_epg_to_contract.app_to_web_consumer.contract_type == "consumer"
    error_message = "WEB_EPG must be the consumer of the app_to_web contract"
  }
}

run "app_to_web_provider_is_app_epg" {
  command = plan
  assert {
    condition     = aci_epg_to_contract.app_to_web_provider.contract_type == "provider"
    error_message = "APP_EPG must be the provider of the app_to_web contract"
  }
}

run "db_to_app_consumer_is_app_epg" {
  command = plan
  assert {
    condition     = aci_epg_to_contract.db_to_app_consumer.contract_type == "consumer"
    error_message = "APP_EPG must be the consumer of the db_to_app contract"
  }
}

run "db_to_app_provider_is_db_epg" {
  command = plan
  assert {
    condition     = aci_epg_to_contract.app_to_db_provider.contract_type == "provider"
    error_message = "DB_EPG must be the provider of the db_to_app contract"
  }
}

run "web_to_internet_consumer_is_ext_net" {
  command = plan
  assert {
    condition     = aci_epg_to_contract.web_to_internet_consumer.contract_type == "consumer"
    error_message = "External network profile must be the consumer of the web_to_internet contract"
  }
}

run "web_to_internet_provider_is_web_epg" {
  command = plan
  assert {
    condition     = aci_epg_to_contract.web_to_internet_provider.contract_type == "provider"
    error_message = "WEB_EPG must be the provider of the web_to_internet contract"
  }
}

run "web_to_internet_contract_has_subject" {
  command = plan
  assert {
    condition     = aci_contract_subject.web_internet.name == "http_https"
    error_message = "web_to_internet contract must have a subject (http_https) defined"
  }
}
