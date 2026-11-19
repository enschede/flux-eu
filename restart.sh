flux suspend kustomization -n flux-system flux-system
flux delete kustomization -s -n flux-system oauth2-client-app
flux delete kustomization -s -n flux-system ping-platform
flux delete kustomization -s -n flux-system ping-secrets
sleep 60
flux resume kustomization -n flux-system flux-system
flux reconcile kustomization -n flux-system flux-system

