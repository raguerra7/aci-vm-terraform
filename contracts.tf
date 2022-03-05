resource "aci_contract" "app_to_web" {
  tenant_dn = aci_tenant.tenant.id
  name      = "app_to_web"
}

resource "aci_contract" "db_to_app" {
  tenant_dn = aci_tenant.tenant.id
  name      = "db_to_app"
}

resource "aci_contract" "web_to_internet" {
  tenant_dn = aci_tenant.tenant.id
  name      = "web_to_internet"
}

resource "aci_filter" "allow_http" {
  tenant_dn = aci_tenant.tenant.id
  name      = "allow_http"
}

resource "aci_filter" "allow_tomcat2" {
  tenant_dn = aci_tenant.tenant.id
  name      = "allow_tomcat2"
}

resource "aci_filter" "allow_mysql" {
  tenant_dn = aci_tenant.tenant.id
  name      = "allow_mysql"
}


resource "aci_filter_entry" "http" {
  filter_dn = aci_filter.allow_http.id
  name      = "http"
  d_from_port = "80"
  d_to_port   = "80"
  prot        = "tcp"
  ether_t     = "ip"
}

resource "aci_filter_entry" "https" {
  filter_dn = aci_filter.allow_http.id
  name      = "https"
  d_from_port = "https"
  d_to_port   = "https"
  prot        = "tcp"
  ether_t     = "ip"
}

resource "aci_filter_entry" "tomcat" {
  filter_dn = aci_filter.allow_tomcat2.id
  name      = "tomcat"
  d_from_port = "8080"
  d_to_port   = "8081"
  prot        = "tcp"
  ether_t     = "ip"
}

resource "aci_filter_entry" "mysql" {
  filter_dn = aci_filter.allow_mysql.id
  name      = "mysql"
  d_from_port = "3306"
  d_to_port   = "3306"
  prot        = "tcp"
  ether_t     = "ip"
}


#Contract Subject Creation
resource "aci_contract_subject" "dev_app" {
  contract_dn = aci_contract.app_to_web.id
  name        = "tomcat"
  relation_vz_rs_subj_filt_att = [aci_filter.allow_tomcat2.id]
}

resource "aci_contract_subject" "dev_db" {
  contract_dn = aci_contract.db_to_app.id
  name        = "mysql"
  relation_vz_rs_subj_filt_att = [aci_filter.allow_mysql.id]
}




# app_to_web contract association with WEB_EPG and APP_EPG
resource "aci_epg_to_contract" "app_to_web_consumer" {
  application_epg_dn = aci_application_epg.WEB_EPG.id
  contract_dn        = aci_contract.app_to_web.id
  contract_type      = "consumer"
}

resource "aci_epg_to_contract" "app_to_web_provider" {
  application_epg_dn = aci_application_epg.APP_EPG.id
  contract_dn        = aci_contract.app_to_web.id
  contract_type      = "provider"
}

# db_to_app contract association with APP_EPG and DB_EPG
resource "aci_epg_to_contract" "db_to_app_consumer" {
  application_epg_dn = aci_application_epg.APP_EPG.id
  contract_dn        = aci_contract.db_to_app.id
  contract_type      = "consumer"
}

resource "aci_epg_to_contract" "app_to_db_provider" {
  application_epg_dn = aci_application_epg.DB_EPG.id
  contract_dn        = aci_contract.db_to_app.id
  contract_type      = "provider"
}

# web_to_internet contract association with APP

resource "aci_epg_to_contract" "web_to_internet_consumer" {
  application_epg_dn = aci_external_network_instance_profile.dev_ext_net_prof.id
  contract_dn        = aci_contract.web_to_internet.id
  contract_type      = "consumer"
}

resource "aci_epg_to_contract" "web_to_internet_provider" {
  application_epg_dn = aci_application_epg.WEB_EPG.id
  contract_dn        = aci_contract.web_to_internet.id
  contract_type      = "provider"
}
