# Allows issuing certificates from the PKI secrets mount.
path "${vault_paths.secrets_engines.pki}/sign/*" {
    capabilities = ["create", "update"]
}

path "${vault_paths.secrets_engines.pki}/issue/*" {
    capabilities = ["create", "update"]
}

path "${vault_paths.secrets_engines.pki}/ca_chain" {
    capabilities = ["read"]
}