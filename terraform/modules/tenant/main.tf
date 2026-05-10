resource "vault_policy" "policies" {
    for_each = local.policies

    name   = each.value.name
    policy = each.value.policy
}
resource "vault_kubernetes_secret_backend_role" "kubernetes_secrets" {
    count = var.secrets_engines.kubernetes != null ? 1 : 0

    backend = var.vault_paths.secrets_engines.kubernetes
    
    name                                  = var.secrets_engines.kubernetes.name
    name_template                         = var.secrets_engines.kubernetes.name_template
    kubernetes_role_name                  = var.secrets_engines.kubernetes.kubernetes_role_name
    kubernetes_role_type                  = var.secrets_engines.kubernetes.kubernetes_role_type
    generated_role_rules                  = var.secrets_engines.kubernetes.generated_role_rules
    allowed_kubernetes_namespaces         = var.secrets_engines.kubernetes.allowed_kubernetes_namespaces
    allowed_kubernetes_namespace_selector = var.secrets_engines.kubernetes.allowed_kubernetes_namespace_selector
    extra_annotations                     = var.secrets_engines.kubernetes.extra_annotations
    extra_labels                          = var.secrets_engines.kubernetes.extra_labels
    
    token_default_ttl = var.secrets_engines.kubernetes.token_default_ttl
    token_max_ttl     = var.secrets_engines.kubernetes.token_max_ttl
}

resource "vault_jwt_auth_backend_role" "github_auth" {
    for_each = var.auth_backends.github != null ? var.auth_backends.github : {}

    backend = var.vault_paths.auth_backends.github

    role_name    = each.value.role_name
    role_type    = "jwt"
    user_claim   = "actor"
    bound_claims = merge({
        repository = "${each.value.organization}/${each.value.repository}"
    }, each.value.extra_bound_claims)

    token_policies = [
        for key in each.value.token_policy_keys :
        vault_policy.policies[key].name
    ]
    token_ttl     = each.value.token_ttl
    token_max_ttl = each.value.token_max_ttl

}

resource "vault_kubernetes_auth_backend_role" "kubernetes_auth" {
    for_each = var.auth_backends.kubernetes

    backend = var.vault_paths.auth_backends.kubernetes

    role_name                        = each.value.role_name
    bound_service_account_names      = each.value.bound_service_account_names
    bound_service_account_namespaces = each.value.bound_service_account_namespaces
    
    token_policies = [
        for key in each.value.token_policy_keys :
        vault_policy.policies[key].name
    ]
    token_max_ttl  = each.value.token_max_ttl
    token_num_uses = each.value.token_num_uses
}
