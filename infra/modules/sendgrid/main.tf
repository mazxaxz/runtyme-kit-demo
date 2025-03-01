terraform {
  required_providers {
    sendgrid = {
      source  = "Trois-Six/sendgrid"
      version = "0.2.1"
    }
  }
}

resource "sendgrid_template" "template" {
  for_each = var.templates

  name       = each.key
  generation = "dynamic"
}

resource "sendgrid_template_version" "template_version" {
  for_each = sendgrid_template.template

  name                   = "${each.value.name}-v1"
  template_id            = each.value.id
  active                 = 1
  html_content           = sensitive(file("${path.root}/${var.templates[each.value.name].relative_path}"))
  generate_plain_content = true
  subject                = var.templates[each.value.name].subject
}

resource "sendgrid_domain_authentication" "default" {
  count = var.domain != null ? 1 : 0

  domain             = var.domain
  automatic_security = true
}
