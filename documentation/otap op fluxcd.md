## OTAP op FluxCD

Folder structure

	+ src
		+ main
			+ deployment
				+ base
					- kustomization.yaml
				+ dev
					- kustomization.yaml
					- patch-dev-deployment.yaml
					- patch-dev-ingress.yaml
				+ prod
					- kustomization.yaml

prod/kustomization.yaml

	apiVersion: kustomize.config.k8s.io/v1beta1  
	kind: Kustomization  
	resources:  
	  - ../base

dev/kustomization.yaml

	apiVersion: kustomize.config.k8s.io/v1beta1  
	kind: Kustomization  
	resources:  
	  - ../base  
	nameSuffix: -dev  
	namespace: cdc-accounts-dev  
	patches:  
	  - path: patch-dev-ingress.yaml  
	    target:  
	      kind: Ingress  
	      name: cdc-client  
	  - path: patch-dev-deployment.yaml  
	    target:  
	      kind: Deployment  
	      name: cdc-client

dev/patch-dev-deployment.yaml

	apiVersion: apps/v1  
	kind: Deployment  
	metadata:  
	  name: cdc-client  
	spec:  
	  replicas: 1


dev/patch-dev.ingress.yaml

	apiVersion: networking.k8s.io/v1  
	kind: Ingress  
	metadata:  
	  name: cdc-client  
	spec:  
	  tls:  
	    - hosts:  
	        - accounts-dev.worldofciam.nl  
	      secretName: worldofciamnl  
	  rules:  
	    - host: accounts-dev.worldofciam.nl  
	      http:  
	        paths:  
	          - path: /  
	            pathType: Prefix  
	            backend:  
	              service:  
	                name: cdc-client-svc  
	                port:  
	                  number: 443

### Kustomazation in Flux infra project voor dev project

	---  
	apiVersion: source.toolkit.fluxcd.io/v1  
	kind: GitRepository  
	metadata:  
	  name: cdc-idm-dev  
	  namespace: flux-system  
	spec:  
	  interval: 1m0s  
	  ref:  
	    branch: dev                    <============== dev branch
	  url: ssh://github.com/enschede/cdc-idm.git  <=========== let op ssh://
	  secretRef:  
	    name: github-deploy
	    
	---  
	apiVersion: kustomize.toolkit.fluxcd.io/v1  
	kind: Kustomization  
	metadata:  
	  name: cdc-idm-dev  
	  namespace: flux-system  
	spec:  
	  interval: 1m  
	  path: ./src/main/deployment/dev  <=========== verwijst naar dev overlay
	  prune: true  
	  sourceRef:  
	    kind: GitRepository  
	    name: cdc-idm-dev             <=========== Verwijst naar dev GitRepo
	    namespace: flux-system  
	  wait: true  
	  decryption:  
	    provider: sops  
	    secretRef:  
	      name: sops-age  
	  dependsOn:  
	    - name: ingress-nginx

