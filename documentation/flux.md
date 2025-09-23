# FluxCD op TransIP

## Flux inrichten

    export GITHUB_TOKEN=<token-met-repo-rechten>
    flux bootstrap github \
    --owner=enschede \
    --repository=flux-eu \
    --branch=main \
    --path=clusters/cluster-k8gqr \
    --personal

Het path geeft aan waar de flux-system folder gevonden kan worden. 
Er kunnen op meerdere clusters in 1 repo opgeslagen worden. 

## Flux commando's

In suspension wordt een flux kustomization niet meer periodiek ge-update.
Een nieuwe versie in git wordt niet meer gelezen en actief gemaakt. Een handmatige reconcile is dan nodig.

    flux suspend kustomization infra-storage --namespace=flux-system
    flux resume kustomization infra-storage --namespace=flux-system
    flux reconcile kustomization infra-storage --namespace=flux-system
    flux reconcile kustomization infra-storage --namespace=flux-system --with-source

--with-source activeert het ophalen van een niewue versie




