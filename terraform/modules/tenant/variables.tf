variable "name" {
    description = "Name of the Vault tenant."
    type        = string
    nullable    = false
}

variable "secrets_engines" {
    description = "Secrets engines to enable for the tenant."
    type = object({
      kubernetes = optional(object({
        allowed_kubernetes_namespaces         = list(string)
        allowed_kubernetes_namespace_selector = optional(string)
        extra_annotations                     = optional(map(string))
        extra_labels                          = optional(map(string))
        generated_role_rules                  = optional(string)
        kubernetes_role_name                  = optional(string)
        kubernetes_role_type                  = optional(string)
        name                                  = string
        name_template                         = optional(string)
        token_default_ttl                     = optional(number, 900)
        token_max_ttl                         = optional(number, 3600)
      }), null)
      kv = optional(object({
        path = string
      }), null)
      pki = optional(object({
        path = string
      }), null)
    })
    default = {}
}

variable "auth_backends" {
    description = "Auth backends to enable for the tenant."
    type = object({
         github = optional(map(object({
            role_name          = string
            organization       = string
            repository         = string
            extra_bound_claims = optional(map(string), {})
            token_ttl          = optional(number, 900)
            token_max_ttl      = optional(number, 3600)
            token_num_uses     = optional(number, 0)
            token_policy_keys  = optional(list(string))
         })), null)
         kubernetes = optional(map(object({
            role_name                        = string
            bound_service_account_names      = list(string)
            bound_service_account_namespaces = list(string)
            token_max_ttl                    = optional(number, 28800)
            token_num_uses                   = optional(number, 0)
            token_policy_keys                = optional(list(string))
         })), null)
    })
    default = {}
}

variable "policies" {
    description = "Map of policies to apply to the tenant."
    type = map(object({
        name     = string
        template = string
    }))
    default = null
}

variable "vault_paths" {
    description = "Vault paths for auth backends and secrets engines."
    type = object({
        secrets_engines = object({
            kubernetes = optional(string, "kubernetes")
            kv         = optional(string, "kv")
            pki        = optional(string, "pki")
        })
        auth_backends = object({
            github     = optional(string, "jwt")
            kubernetes = optional(string, "kubernetes")
        })
    })
}