resource "auth0_email_provider" "smtp" {
  count = var.custom_smtp ? 1 : 0

  name                 = "smtp"
  enabled              = true
  default_from_address = var.smtp_from_address

  credentials {
    smtp_host = var.smtp_host
    smtp_port = var.smtp_port
    smtp_user = var.smtp_username
    smtp_pass = var.smtp_password
  }
}

resource "auth0_email_template" "email_templates" {
  for_each = { for i, v in var.email_templates: v.template_key => v }

  template = each.value.template_key
  subject  = each.value.subject
  body     = sensitive(file(each.value.relative_path))
  from     = var.custom_smtp ? var.smtp_from_address : ""
  syntax   = "liquid"
  enabled  = true 

  result_url              = var.site_url
  url_lifetime_in_seconds = 432000 // 5 days
}
