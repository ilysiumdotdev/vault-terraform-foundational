# Allows read/write access to the specified KV secrets path.
path "${vault_paths.secrets_engines.kv}/data/${tenant.secrets_engines.kv.path}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "${vault_paths.secrets_engines.kv}/metadata/${tenant.secrets_engines.kv.path}/*" {
  capabilities = ["read", "list", "delete"]
}