# College Department Information Portal

A lightweight department portal built with HTML, CSS, and Nginx. It is containerized with Docker and can be deployed to Kubernetes with a Jenkins CI/CD pipeline.

## Local development

```bash
docker build -t college-department-portal:local .
docker run --rm -p 8080:80 college-department-portal:local
```

Open http://localhost:8080.

## Jenkins pipeline

The Jenkinsfile performs these stages:

1. Clone the GitHub repository.
2. Build the Docker image.
3. Authenticate with Docker Hub and push the image.
4. Apply the Kubernetes manifests.
5. Wait for the rolling deployment to finish.

Create the following Jenkins credentials:

- `dockerhub-credentials` — username and password for Docker Hub.
- `k8s-kubeconfig` — a Kubernetes kubeconfig file credential.

The deployment uses the `sanjeevsekar23/college-department-portal:latest` image and exposes port `30080` through a NodePort service.

## Kubernetes

```bash
kubectl apply -f k8s/
kubectl get deployment -n college-department
kubectl get service -n college-department
kubectl port-forward service/college-department-portal 8080:80 -n college-department
```

The namespace, deployment, and service are defined under `k8s/`.

## Deployment requirements

- Kubernetes cluster with permission to create namespaces, deployments, services, and rollouts.
- Jenkins with Git, Docker, Kubernetes CLI, and Credentials plugins installed.
- Docker Hub repository access for the configured Docker Hub account.
- Jenkins pipeline configured to run `main` branch builds.
