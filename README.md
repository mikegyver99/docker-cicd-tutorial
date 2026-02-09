# Docker CI/CD to AKS (GitHub Actions)

This repo builds a Docker image, publishes it to GitHub Container Registry (GHCR), and deploys it to a dev namespace on Azure Kubernetes Service (AKS) using GitHub Actions.

## What It Does

- Builds the Docker image from the local Dockerfile.
- Pushes the image to GHCR as `ghcr.io/<owner>/<repo>:<commit_sha>`.
- Deploys the image to AKS using Kubernetes manifests in `k8s/`.

## GitHub Actions Workflow

The workflow lives at:

- `.github/workflows/aks.yml`

It runs on:

- `workflow_dispatch` (manual trigger)
- `push` to the `main` branch

Jobs:

- Build image
- Package Registry (GHCR push)
- Deploy Dev (AKS)

## Required GitHub Secrets

Create these repository secrets:

- `AZURE_CREDENTIALS` - Azure service principal JSON for `azure/login`
- `AKS_RESOURCE_GROUP` - Resource group containing the AKS cluster
- `AKS_CLUSTER_NAME` - AKS cluster name
- `AKS_NAMESPACE` - Kubernetes namespace for the dev deployment

Example service principal JSON format:

```
{
  "clientId": "<appId>",
  "clientSecret": "<password>",
  "subscriptionId": "<subscriptionId>",
  "tenantId": "<tenantId>"
}
```

## Kubernetes Manifests

- `k8s/deployment.yaml` - Deployment for the web app
- `k8s/service.yaml` - LoadBalancer service for HTTP

The workflow replaces the image in the Deployment at deploy time.

## How To Use

1. Create the required GitHub Secrets.
2. Commit and push to `main`, or run the workflow manually from the Actions tab.
3. After the deploy job succeeds, get the service external IP:

```
kubectl get svc webapp -n <namespace>
```

Then open the external IP in your browser.

## Local Build (Optional)

```
docker build -t local/webapp:dev .
```
