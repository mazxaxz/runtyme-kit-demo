resource "auth0_client" "default" {
  name        = "${var.project_name} - Auth"
  description = "Created by runtyme.co"
  app_type    = "regular_web"

  custom_login_page_on                = false
  is_first_party                      = true
  is_token_endpoint_ip_header_trusted = false
  oidc_conformant                     = true
  require_proof_of_possession         = false
  cross_origin_auth                   = false // only if custom HTML components are used
  
  callbacks           = var.callback_urls
  allowed_logout_urls = var.logout_urls
  allowed_origins     = var.allowed_origins
  web_origins         = var.allowed_origins

  grant_types = concat(
    ["authorization_code"],
    var.otp_enabled ? ["http://auth0.com/oauth/grant-type/passwordless/otp"] : [],
    var.password_enabled ? ["password"] : [],
    var.otp_enabled || var.password_enabled ? ["refresh_token"] : [],
  )

  jwt_configuration {
    lifetime_in_seconds = 3600
    secret_encoded      = true
    alg                 = "RS256"
  }

  dynamic "refresh_token" {
    for_each = var.otp_enabled || var.password_enabled ? ["apply"] : []

    content {
      leeway              = 0
      idle_token_lifetime = 2592000
      token_lifetime      = 31557600
      rotation_type       = "rotating"
      expiration_type     = "expiring"
    }
  }
}

data "auth0_client" "default" {
  client_id = auth0_client.default.client_id
}

resource "auth0_connection_client" "default_client_passwordless_conn_assoc" {
  count = var.otp_enabled ? 1 : 0

  connection_id = one(auth0_connection.passwordless_email[*].id)
  client_id     = auth0_client.default.id
}

resource "auth0_connection_client" "default_client_email_password_conn_assoc" {
  count = var.password_enabled ? 1 : 0

  connection_id = one(auth0_connection.email_password[*].id)
  client_id     = auth0_client.default.id
}

resource "auth0_prompt" "authentication_profile" {
  universal_login_experience     = "new"
  identifier_first               = var.otp_enabled && !var.password_enabled
  webauthn_platform_first_factor = false
}
