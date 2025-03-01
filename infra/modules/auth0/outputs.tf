output "jwt_issuer" {
  value       = "https://${data.auth0_tenant.self.domain}/"
  description = "Issuer of Auth0's JWT Token"
}

output "client_id" {
  value       = auth0_client.default.id
  description = "Auth client ID, also the audience value of Auth0's JWT Token"
}

output "client_secret" {
  value       = data.auth0_client.default.client_secret
  description = "Secret of created client, also used for Auth0's JWT token validation"
}
