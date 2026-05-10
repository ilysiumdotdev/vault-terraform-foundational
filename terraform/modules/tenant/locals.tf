locals {
    policy_template_files = fileset("${path.module}/policy", "*.hcl.tpl")
    policy_templates = {
        for file in local.policy_template_files :
        trimsuffix(file, ".hcl.tpl") => file("${path.module}/policy/${file}")
    }
    policies_rendered = {
        for key, policy in var.policies :
        key => {
            name   = policy.name
            policy = templatestring(local.policy_templates[policy.template], {
                tenant = { secrets_engines = var.secrets_engines }
                vault_paths = var.vault_paths
            }) 
        } 
    }
    policies = local.policies_rendered
}
