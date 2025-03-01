// Get full version at https://runtyme.co/#pricing
#  ________________________________________
# |  ____________________________________  |
# | | ============== Auth0 ============= | |
# | |____________________________________| |
# |________________________________________|

locals {
  auth0_enabled      = try(local.auth0.enabled, false)
  auth0_otp_enabled  = try(local.auth0.otp.enabled, false)
  auth0_pwd_enabled  = try(local.auth0.password.enabled, false)
  auth0_use_sendgrid = try(local.auth0.smtp.use_sendgrid, false)
}

module "auth0" {
  source = "./modules/auth0"
  count  = local.auth0_enabled ? 1 : 0

  project_name   = try(local.auth0.project_name, "")
  disable_signup = try(local.auth0.disable_signup, false)

  site_url      = try(local.auth0.site_url, "http://localhost:3000")
  logout_urls   = try(local.auth0.after_logout_url, "") != "" ? [local.auth0.after_logout_url] : []
  callback_urls = try(local.auth0.site_url, "") != "" ? [local.auth0.site_url] : ["http://localhost:3000"]

  otp_enabled                 = local.auth0_otp_enabled
  otp_expire_in               = local.auth0_otp_enabled ? try(local.auth0.otp.expire_in, 3600) : 0
  otp_length                  = local.auth0_otp_enabled ? try(local.auth0.otp.code_length, 6) : 0
  otp_email_subject           = local.auth0_otp_enabled ? try(local.auth0.otp.email_subject, "") : ""
  otp_email_template_filepath = local.auth0_otp_enabled ? try(local.auth0.otp.email_template_relative_path, "") != "" ? "${path.root}/${local.auth0.otp.email_template_relative_path}" : "" : ""

  password_enabled    = local.auth0_pwd_enabled
  password_policy     = local.auth0_pwd_enabled ? try(local.auth0.password.policy, "good") : ""
  password_min_length = local.auth0_pwd_enabled ? try(local.auth0.password.min_length, 8) : 0

  custom_smtp       = local.auth0_use_sendgrid && local.sendgrid_enabled
  smtp_host         = local.auth0_use_sendgrid && local.sendgrid_enabled ? try(local.default_sendgrid_host, "") : ""
  smtp_port         = local.auth0_use_sendgrid && local.sendgrid_enabled ? try(local.default_sendgrid_port, 0) : 0
  smtp_username     = local.auth0_use_sendgrid && local.sendgrid_enabled ? try(local.default_sendgrid_user, "") : ""
  smtp_password     = local.auth0_use_sendgrid && local.sendgrid_enabled ? var.SENDGRID_API_KEY : ""
  smtp_from_address = local.auth0_use_sendgrid && local.sendgrid_enabled ? try(local.sendgrid.sender_email, "") : ""

  allowed_origins = local.domain_root_exists ? ["https://*.${local.domain.root}"] : [try(local.auth0.site_url, "http://localhost:3000")]

  email_templates = [for k, t in try(local.auth0.email_templates, {}) : { template_key = k, subject = t.subject, relative_path = "${path.root}/${t.template_relative_path}" }]
}
