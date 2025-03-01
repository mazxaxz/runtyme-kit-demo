// Get full version at https://runtyme.co/#pricing

locals {
  domain_root_exists = try(local.domain.root, "") != ""
}
