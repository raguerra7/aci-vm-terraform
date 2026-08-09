# Security

## Credential Handling

Do not commit APIC, vSphere, or other infrastructure credentials. Keep local variable files, Terraform state, private keys, plan files, and environment files outside version control. Use environment variables or an approved secrets manager where possible.

If a credential is committed accidentally, revoke or rotate it immediately. Removing it from the latest commit does not remove it from Git history.

## Reporting a Security Issue

Do not open a public issue containing credentials, internal addresses, or other sensitive infrastructure details. Contact the repository owner privately with a concise description of the issue and the affected files.
