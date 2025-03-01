// Get full version at https://runtyme.co/#pricing

terraform {
  required_providers {
    sendgrid = {
      source  = "Trois-Six/sendgrid"
      version = "0.2.1"
    }
    auth0 = {
      source  = "auth0/auth0"
      version = "1.9.0"
    }
  }
}

provider "sendgrid" {
  api_key = var.SENDGRID_API_KEY
}

provider "auth0" {
  domain        = var.AUTH0_DOMAIN
  client_id     = var.AUTH0_CLIENT_ID
  client_secret = var.AUTH0_CLIENT_SECRET
  debug         = false
}
