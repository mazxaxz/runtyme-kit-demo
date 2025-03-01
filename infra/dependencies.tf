// Get full version at https://runtyme.co/#pricing

#  ________________________________________
# |  ____________________________________  |
# | | ============ SendGrid ============ | |
# | |____________________________________| |
# |________________________________________|

locals {
  sendgrid_enabled = try(local.sendgrid.enabled, false)
  // https://www.twilio.com/docs/sendgrid/for-developers/sending-email/integrating-with-the-smtp-api
  default_sendgrid_host = "smtp.sendgrid.net"
  default_sendgrid_port = "465" // SSL
  default_sendgrid_user = "apikey"
}

module "sendgrid" {
  source = "./modules/sendgrid"
  count  = local.sendgrid_enabled && local.domain_root_exists ? 1 : 0

  domain    = local.domain.root
  templates = try(local.sendgrid.templates, {})
}
