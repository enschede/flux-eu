## SOPS
Zie werkend voorbeeld in ingress-nginx

### Installeer age

	brew install age

Check of het werkt:

	age-keygen --version


### Genereer age keypair

Genereer de sleutel en sla hem lokaal op:

	age-keygen -o age.key

Output (voorbeeld):

	# created: 2025-09-22T20:30Z
	# public key: age1y0exampleexampleexample
	AGE-SECRET-KEY-1X2Y3Z4EXAMPLEEXAMPLEEXAMPLE


- De regel met public key: age1... → komt in je repo (in .sops.yaml).
- De regel AGE-SECRET-KEY-... → stop je in Kubernetes als secret.

### Zet de private key in Kubernetes

Plaats de secret in flux-system namespace (zodat Flux kan decrypten):

	kubectl -n flux-system create secret generic sops-age \
	--from-file=age.agekey=./age.key

Tip: verwijder of beveilig age.key lokaal daarna. Je hebt ‘m niet meer nodig, Flux heeft de key nu in de cluster.


### Zet public key in repo

Maak een .sops.yaml bovenin je repo met je public key:


	creation_rules:
		path_regex: .*\.enc\.yaml$
		encrypted_regex: ^(data|stringData)$
		key_groups:
			- age:
				- age1y0exampleexampleexample

### Maak een secret
Bijv. db-secret.enc.yaml, en versleutel hem:

	sops --encrypt --in-place db-secret.enc.yaml


### Zet in je Flux Kustomization:

	spec:
	  decryption:
	    provider: sops
	    secretRef:
          name: sops-age

Commit & push → Flux decrypt de secret automatisch bij sync.
