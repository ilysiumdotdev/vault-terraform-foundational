locals {
    tenant_files = fileset(
        path.module, "tenants/*.{yml,yaml}"
    )
    tenants_contents = {
        for file in local.tenant_files :
        basename(file) => yamldecode(file(file))
    }
    tenants = {
        for k, v in local.tenants_contents :
        v.name => v
    }
}

locals {
    vault_paths = {
        auth_backends = {
            github     = vault_jwt_auth_backend.github.path
            kubernetes = vault_auth_backend.kubernetes.path
        }
        secrets_engines = {
            kubernetes = vault_kubernetes_secret_backend.kubernetes.path
            kv         = vault_mount.kv_v2.path
            pki        = vault_mount.pki.path
        }
    }
}
