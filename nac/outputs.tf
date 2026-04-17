output "model" {
  description = "The full merged NaC data model as applied to APIC"
  value       = module.aci.model
  sensitive   = true
}
