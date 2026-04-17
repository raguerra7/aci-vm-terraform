# aci-nac-terraform

Cisco ACI **Network as Code** — 3-tier application infrastructure (web, app, DB) defined entirely in YAML and deployed with the [`netascode/nac-aci`](https://registry.terraform.io/modules/netascode/nac-aci/aci/latest) Terraform module.

## Why Network as Code?

Traditional Terraform for ACI means writing one `resource` block per ACI object — hundreds of blocks for a real fabric. NaC flips this: you **describe the desired state in YAML files**, and a single opinionated Terraform module translates that into every required ACI object, handling all dependencies automatically.

| Traditional Terraform | Network as Code |
|---|---|
| One `.tf` block per ACI object | One YAML file per domain |
| Logic and data are mixed | Logic lives in the module, data lives in YAML |
| Hard to diff, hard to review | YAML diffs are human-readable |
| Requires Terraform expertise to modify | Ops teams can edit YAML without Terraform knowledge |

## Architecture

```
Internet
   │
   │  (web-to-internet contract — HTTP/HTTPS)
   ▼
┌─────────┐        ┌─────────┐        ┌────────┐
│ WEB_EPG │──────▶│ APP_EPG │──────▶│ DB_EPG │
│10.100.1 │  app-  │10.100.2 │  db-   │10.100.3│
│  .0/24  │to-web  │  .0/24  │to-app  │  .0/24 │
└─────────┘(Tomcat)└─────────┘(MySQL) └────────┘

All EPGs attached to VMM domain: vDS-Comp-01
```

## Repository Structure

```
.
├── main.tf                     # Single module call — all logic is here
├── versions.tf                 # Provider requirements + ACI provider config
├── variables.tf                # Credentials and feature flags
├── outputs.tf                  # Exposes the merged NaC model
├── data/
│   ├── tenant_3tier_app.yaml   # VRF, Bridge Domains, EPGs, Contracts, Filters, L3Out
│   └── access_policies.yaml    # VLAN pools, VMM domain, AEPs, interface policies
├── tests/
│   └── yaml_schema.tftest.hcl  # Validates YAML files parse correctly (mock providers)
└── .github/
    └── workflows/
        └── validate.yml        # CI: fmt, validate, test, yamllint, tfsec, tflint
```

## Quick Start

### 1. Prerequisites

- Terraform ≥ 1.8.0
- Access to a Cisco APIC (lab or production)

### 2. Configure credentials

Create a `terraform.tfvars` file (never commit this):

```hcl
aci_username = "admin"
aci_password = "your-password"
aci_url      = "https://apic.example.com"
aci_insecure = true   # set false in production with a valid TLS cert
```

### 3. Deploy

```bash
terraform init
terraform plan
terraform apply
```

### 4. Run tests (no APIC required)

```bash
terraform test
```

### 5. Destroy

```bash
terraform destroy
```

## Customising the Data Model

All network state lives in `data/`. Edit YAML — no Terraform knowledge required.

### Add a new tenant

Create `data/my_tenant.yaml`:

```yaml
apic:
  tenants:
    - name: my-tenant
      vrfs:
        - name: my-vrf
      bridge_domains:
        - name: my-bd
          vrf: my-vrf
          subnets:
            - ip: 192.168.10.1/24
              scope: [private]
      application_profiles:
        - name: my-app
          endpoint_groups:
            - name: WEB
              bridge_domain: my-bd
```

Then `terraform apply` — no changes to `.tf` files needed.

### Add a VLAN range

In `data/access_policies.yaml`, under the appropriate `vlan_pools` entry:

```yaml
ranges:
  - from: 1100
    to: 1199
```

## Feature Flags

Control which parts of the fabric are managed via variables:

| Variable | Default | Description |
|---|---|---|
| `manage_tenants` | `true` | Deploy VRFs, BDs, EPGs, contracts |
| `manage_access_policies` | `true` | Deploy VLAN pools, domains, AEPs |

Set either to `false` to exclude that domain from Terraform management without deleting existing state.

## What Is Deployed

### Tenant: `3tier-app`

| Resource | Name |
|---|---|
| VRF | `prod-vrf` |
| Bridge Domains | `web-bd`, `app-bd`, `db-bd` |
| Application Profile | `3tier-app` |
| EPGs | `WEB_EPG`, `APP_EPG`, `DB_EPG` |
| Contracts | `app-to-web` (Tomcat 8080-8081), `db-to-app` (MySQL 3306), `web-to-internet` (HTTP/HTTPS) |
| Filters | `allow-http`, `allow-tomcat`, `allow-mysql` |
| L3Out | `internet` (ext subnet 10.0.3.28/27) |

### Access Policies

| Resource | Name |
|---|---|
| VLAN Pools | `vmware-vlan-pool` (1000-1099 dynamic), `phys-vlan-pool` (100-199 static) |
| VMM Domain | `vDS-Comp-01` |
| Physical Domain | `phys-domain` |
| AEPs | `vmware-aep`, `phys-aep` |
| Interface Policy Groups | `vmware-uplink-pg` (vPC/LACP), `server-access-pg` (access) |

## References

- [Cisco NaC Portal](https://netascode.cisco.com)
- [netascode/nac-aci Terraform module](https://registry.terraform.io/modules/netascode/nac-aci/aci/latest)
- [NaC GitHub Organization](https://github.com/netascode)
- [ACI Terraform Provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest)
