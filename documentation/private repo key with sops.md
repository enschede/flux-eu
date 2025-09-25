## Private repo key in SOPS
Private repo deploy key ook met SOPS coderen

### flux-system/gotk-sync.yaml
Decryption provider toevoeren aan Kustomization van FluxCD zelf

	apiVersion: kustomize.toolkit.fluxcd.io/v1  
	kind: Kustomization  
	metadata:  
	  name: flux-system  
	  namespace: flux-system  
	spec:  
	  interval: 10m0s  
	  path: ./clusters/cluster-k8gqr  
	  prune: true  
	  sourceRef:  
	    kind: GitRepository  
	    name: flux-system  
	  decryption:  
	    provider: sops  
	    secretRef:  
	      name: sops-age

### Encrypted key toevoegen aan GitRepository

	---  
	apiVersion: v1  
	data:  
	  identity: 
	    ...
	  identity.pub: 
	    ... 
	  known_hosts: 
	    ...
	kind: Secret  
	metadata:  
	  name: github-deploy  
	  namespace: flux-system  
	type: Opaque  
	sops:  
	   ...
	  
	  
	---  
	apiVersion: source.toolkit.fluxcd.io/v1  
	kind: GitRepository  
	  secretRef:  
	    name: github-deploy
