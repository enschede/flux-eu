# Private repo
## Deployment key

### Create a deploy key
	# In een werkmap:
	ssh-keygen -t ed25519 -C "deploy-key voor ORG/REPO" -f ./github-deploy -N ""

### Zet deploy key in Flux
Direct

	flux create secret git github-deploy \
	  --namespace=flux-system \
	  --url=ssh://git@github.com/ORG/REPO.git \
	  --private-key-file=./github-deploy

Of indirect

	flux create secret git github-deploy \
	  --namespace=flux-system \
	  --url=ssh://git@github.com/ORG/REPO.git \
	  --private-key-file=./github-deploy \
	  --export > secret.yaml

### Zit pub key in GitHub
Zet key in GitHub: **repo** > **settings** > **Deploy keys**

### GitHub key gebruiken in GitRepository descriptor
(Attentie: de url gebruikt een ssh://)

	---  
	apiVersion: source.toolkit.fluxcd.io/v1  
	kind: GitRepository  
	metadata:  
	  name: cdc-idm  
	  namespace: flux-system  
	spec:  
	  interval: 1m0s  
	  ref:  
	    branch: main  
	  url: ssh://github.com/enschede/cdc-idm.git  
	  secretRef:  
	    name: github-deploy

