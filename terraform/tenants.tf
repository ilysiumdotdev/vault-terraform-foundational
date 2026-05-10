module "tenants" {
    source = "./modules/tenant"

    for_each = local.tenants
    
    name            = each.value.name
    secrets_engines = each.value.secrets_engines
    auth_backends   = each.value.auth_backends
    policies        = each.value.policies

    vault_paths = local.vault_paths
}