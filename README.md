## ACI-Terraform 3 tiers application profile

This repo will create a tenant with all the necesary configuration to create a 3tier apps

# Make it work:

1. Clone the Repo
```
git clone https://github.com/gnuowned/aci-terraform
cd aci-terraform
```
2. Modify `main.tf-example` to your settings and rename it to `main.tf`
3. Modify the VMM Domain DN in file `application_profile.tf` with your proper VMM-Domain DN
4. Run the plan and apply
```
terraform plan
terraform apply