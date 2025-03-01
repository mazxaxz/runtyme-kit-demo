output "built_template_envs" {
  value = {
    for v in sendgrid_template.template : "SENDGRID_TEMPLATE_ID_${replace(upper(v.name), "-", "_")}" => v.id
  }
  description = "Map of built email tables IDs in environmental variables way"
  sensitive   = false
}

output "dns_records" {
  value       = one(sendgrid_domain_authentication.default[*]).dns
  description = "Email DNS records for Gateway registration"
  sensitive   = false
}