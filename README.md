# ArgoCD app of app pattern example

Sample **mono-repository structure** for orchestrating K8s deployment in a GitOps manner. The core principle of this approach is having a single ArgoCD installation that orchestrate deployment to **multiple clusters**

## Initialization
When bootstrapping ArgoCD, you would need to configure ArgoCD to check all applications in the "orchestrating" cluster ([example here](argocd/clusters/onprem/hk/prod/ci-01/applications))

If you install ArgoCD via the [official Helm chart](https://github.com/argoproj/argo-helm/tree/argo-cd-4.6.0/charts/argo-cd), this is as simple as:
```yaml
  additionalApplications:
    - name: onprem-hk-prod-ci-01-applications
      namespace: argocd
      additionalLabels:
        vyon.tech/created-by: helm-argocd
      project: default
      source:
        path: argocd/clusters/onprem/hk/prod/ci-01/applications
        repoURL: <path_to_github_repo>
        targetRevision: HEAD
        directory:
          recurse: true
      destination:
        name: in-cluster
        namespace: argocd
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
        syncOptions:
          - CreateNamespace=true
          - ApplyOutOfSyncOnly=true

configs:
  credentialTemplates:
    gh-ssh-creds:
      url: git@github.com:<org_name>
      sshPrivateKey: |
        -----BEGIN OPENSSH PRIVATE KEY-----
        -----END OPENSSH PRIVATE KEY-----

  repositories:
    gh-main-deployment-repo:
      url: git@github.com:<org_name>/<repo_name>.git
```

> You will need to configure SSH key and repositories in ArgoCD as well

From there, all other new applications are automatically picked up, no need to manually add applications via ArgoCD UI/CLI

## Adding new clusters
New clusters do not need to install ArgoCD to be managed. All we need to do is provide the central ArgoCD instance K8s + network [access](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#clusters) to the target cluster, and add the new cluster via the [cluster folder](argocd/clusters/onprem/hk/prod/ci-01/applications/clusters)
