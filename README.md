# Cisco ACI 3-Tier Application with Terraform

Terraform configuration for building a Cisco ACI tenant and the core policy objects required for a three-tier application environment, including application profiles, EPGs, contracts, and VMware VMM integration.

## Overview

This repository is a lab and reference implementation for modeling a web, application, and database architecture in Cisco ACI. It also demonstrates how ACI-created port groups can be consumed by Terraform when deploying virtual machines to VMware vSphere.

## Architecture

The configuration creates:

- One Cisco ACI tenant and VRF
- Separate bridge domains and subnets for the web, application, and database tiers
- One application profile with a dedicated EPG for each tier
- Contracts and filters for HTTP/HTTPS, application, and database traffic
- VMware VMM domain associations for the application EPGs
- Optional vSphere virtual machines connected to the ACI-backed port groups

Traffic relationships are represented as follows:

```text
External network -> Web EPG -> Application EPG -> Database EPG
```

## What This Repository Contains

- ACI tenant, VRF, bridge domain, subnet, EPG, contract, and L3Out resources
- VMware vSphere data sources and optional three-tier VM deployment
- Input variables for APIC, vSphere, VMM, VM sizing, and DNS settings
- Terraform tests for variable validation, networking, contracts, and VM deployment
- A GitHub Actions workflow for Terraform validation

## Prerequisites

- Terraform 1.7 or later
- Access to a Cisco APIC with permission to create the required policy objects
- An existing Cisco ACI VMware VMM domain
- VMware vCenter access when deploying the optional virtual machines
- A compatible VM template, datastore, resource pool, and vSphere datacenter

Review provider compatibility and test the configuration in a non-production environment before use.

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/raguerra7/aci-vm-terraform.git
   cd aci-vm-terraform
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Provide environment-specific values through an untracked `.tfvars` file, environment variables, or another approved secret-management workflow. Do not place real credentials in `main.tf` or commit them to Git.

4. Format and validate the configuration:

   ```bash
   terraform fmt -check
   terraform validate
   terraform test
   ```

5. Review the execution plan before making any changes:

   ```bash
   terraform plan -var-file="local.auto.tfvars"
   ```

6. Apply only after the plan has been reviewed and approved:

   ```bash
   terraform apply -var-file="local.auto.tfvars"
   ```

`main.tf-example` is retained as a legacy reference. The active provider configuration in `main.tf` already consumes input variables, so the example file should not be copied over `main.tf`.

## Repository Structure

```text
.
├── application_profile.tf   # Application profile, EPGs, and VMM associations
├── contracts.tf             # Contracts, filters, subjects, and EPG bindings
├── main.tf                  # Terraform provider configuration
├── tenant.tf                # Tenant, VRF, bridge domains, subnets, and L3Out
├── variables.tf             # Input variable definitions and validation
├── versions.tf              # Terraform version constraint
├── vmware.tf                # Optional vSphere virtual machine deployment
└── tests/                   # Terraform test definitions
```

## Security Notes

- Never commit APIC or vSphere credentials, private keys, state files, or plan files.
- Treat Terraform state as sensitive because it may contain infrastructure data and provider values.
- Prefer environment variables or an approved secrets manager for credentials.
- The providers currently permit unverified TLS certificates for lab compatibility. Use trusted certificates and stricter TLS validation where possible.
- Always inspect `terraform plan` output before applying changes.

See [SECURITY.md](SECURITY.md) for reporting and credential-handling guidance.

## Intended Use

This project is intended for labs, learning, demonstrations, and reference implementations. Adapt addressing, naming, contracts, domain associations, and security policy to the target environment.

## Disclaimer

This is an independent reference implementation and is not an official Cisco implementation or supported Cisco product. Validate all changes in a lab before considering production use.
