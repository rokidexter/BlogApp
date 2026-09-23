# Production-Level Three-Tier Blog Application CI/CD Deployment on Amazon EKS

A production-oriented DevOps and DevSecOps implementation of a three-tier Blog Application deployed on **Amazon Elastic Kubernetes Service (EKS)** with an automated **Jenkins CI/CD pipeline**.

The project demonstrates:

* GitHub-based source control
* Jenkins CI/CD automation
* SonarQube static code analysis
* SonarQube Quality Gate enforcement
* Docker containerization
* Trivy container vulnerability scanning
* Amazon ECR image management
* Amazon EKS deployment
* Kubernetes rolling deployments
* Kubernetes Secrets
* Kubernetes NetworkPolicy
* MySQL StatefulSet
* Persistent storage using AWS EBS CSI
* Prometheus and Grafana monitoring
* Alertmanager
* Kubernetes health probes
* Resource requests and limits
* Non-root container execution
* Kubernetes troubleshooting and validation

---

# 🚀 1. Project Overview

The application is a three-tier web application consisting of:

```text
Frontend
React + Nginx
     │
     ▼
Backend
Node.js + Express
     │
     ▼
Database
MySQL
```

The complete application is containerized and deployed on an Amazon EKS cluster.

The CI/CD workflow is:

```text
Developer
    │
    ▼
 GitHub
    │
    ▼
 Jenkins
    │
    ├── Checkout
    │
    ├── Environment Verification
    │
    ├── Backend Build & Test
    │
    ├── Frontend Build
    │
    ├── SonarQube Analysis
    │
    ├── SonarQube Quality Gate
    │
    ├── Docker Build
    │
    ├── Trivy Security Scan
    │
    ├── Amazon ECR Push
    │
    └── Deploy to Amazon EKS
             │
             ▼
       ┌───────────────┐
       │    Frontend   │
       │ React + Nginx │
       └───────┬───────┘
               │
               ▼
       ┌───────────────┐
       │    Backend    │
       │ Node + Express│
       └───────┬───────┘
               │
               ▼
       ┌───────────────┐
       │     MySQL     │
       │  StatefulSet  │
       └───────────────┘

             Monitoring
                 │
        ┌────────┴────────┐
        ▼                 ▼
   Prometheus          Grafana
        │
        ▼
   Alertmanager
```

---

# 🏗️ 2. Architecture

```text
                         ┌─────────────────────┐
                         │       GitHub        │
                         │  Source Repository  │
                         └──────────┬──────────┘
                                    │
                                    │ Webhook
                                    ▼
                         ┌─────────────────────┐
                         │       Jenkins       │
                         │     CI/CD Server    │
                         └──────────┬──────────┘
                                    │
             ┌──────────────────────┼─────────────────────┐
             │                      │                     │
             ▼                      ▼                     ▼
        SonarQube                Docker                 Trivy
       Code Analysis             Build              Vulnerability
       Quality Gate                                    Scan
             │                      │                     │
             └──────────────────────┼─────────────────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │     Amazon ECR      │
                         │ Container Registry  │
                         └──────────┬──────────┘
                                    │
                                    │ Pull Images
                                    ▼
                    ┌─────────────────────────────┐
                    │         Amazon EKS          │
                    │                             │
                    │  ┌───────────────────────┐  │
                    │  │ Frontend Deployment   │  │
                    │  │ React + Nginx          │  │
                    │  │ 2 Replicas             │  │
                    │  └───────────┬───────────┘  │
                    │              │              │
                    │              ▼              │
                    │  ┌───────────────────────┐  │
                    │  │ Backend Deployment    │  │
                    │  │ Node.js + Express     │  │
                    │  │ 2 Replicas             │  │
                    │  └───────────┬───────────┘  │
                    │              │              │
                    │              ▼              │
                    │  ┌───────────────────────┐  │
                    │  │ MySQL StatefulSet     │  │
                    │  │ 1 Replica             │  │
                    │  │ Persistent EBS Volume │  │
                    │  └───────────────────────┘  │
                    │                             │
                    └──────────────┬──────────────┘
                                   │
                     ┌─────────────┴─────────────┐
                     │                           │
                     ▼                           ▼
              ┌──────────────┐           ┌──────────────┐
              │  Prometheus  │           │   Grafana    │
              │  Monitoring  │           │ Visualization│
              └──────┬───────┘           └──────────────┘
                     │
                     ▼
              ┌──────────────┐
              │ Alertmanager │
              └──────────────┘
```

---

# 🧰 3. Technology Stack

## Application

| Layer         | Technology |
| ------------- | ---------- |
| Frontend      | React      |
| Web Server    | Nginx      |
| Backend       | Node.js    |
| API Framework | Express.js |
| Database      | MySQL 8.0  |

## DevOps / DevSecOps

| Area                  | Technology         |
| --------------------- | ------------------ |
| Source Control        | Git / GitHub       |
| CI/CD                 | Jenkins            |
| Containerization      | Docker             |
| Container Registry    | Amazon ECR         |
| Kubernetes            | Amazon EKS         |
| Cloud                 | AWS                |
| Code Quality          | SonarQube          |
| Quality Gate          | SonarQube          |
| Vulnerability Scanner | Trivy              |
| Monitoring            | Prometheus         |
| Visualization         | Grafana            |
| Alerting              | Alertmanager       |
| Kubernetes Metrics    | kube-state-metrics |
| Node Metrics          | Node Exporter      |
| Persistent Storage    | AWS EBS CSI        |
| Database              | MySQL StatefulSet  |

> **Nexus is not used in this implementation.**
>
> Docker images are pushed directly from Jenkins to Amazon ECR.

---

# 📁 4. Repository Structure

```text
BlogReact/
│
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   ├── package-lock.json
│   └── src/
│
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   ├── package-lock.json
│   └── src/
│
├── database/
│   └── ...
│
├── Jenkinsfile
│
├── backend.yaml
├── frontend.yaml
├── mysql.yaml
├── mysql-networkpolicy.yaml
├── k8s-mysql-storageclass.yaml
│
└── README.md
```

The repository contains the application source code, Dockerfiles, Jenkins pipeline, and Kubernetes deployment manifests.

---

# 🔄 5. CI/CD Pipeline

The Jenkins pipeline is implemented as a Declarative Pipeline.

The actual pipeline flow is:

```text
GitHub
   │
   ▼
Checkout
   │
   ▼
Verify Environment
   │
   ▼
Backend Build & Test
   │
   ▼
Frontend Build
   │
   ▼
SonarQube Analysis
   │
   ▼
SonarQube Quality Gate
   │
   ▼
Docker Build
   │
   ▼
Trivy Security Scan
   │
   ▼
Amazon ECR Push
   │
   ▼
Amazon EKS Deployment
   │
   ▼
Rollout Validation
```

The Jenkins pipeline currently performs these stages directly.

---

# 6. GitHub Source Control

GitHub is used as the central source-code repository.

It contains:

* React frontend
* Node.js backend
* Dockerfiles
* Kubernetes manifests
* Jenkinsfile
* MySQL configuration
* NetworkPolicy
* StorageClass
* Documentation

Jenkins checks out the repository at the beginning of the pipeline.

---

# 🔨 7. Jenkins CI/CD

Jenkins is the automation engine for the complete application delivery process.

The pipeline begins with:

```text
GitHub
   │
   ▼
Jenkins
   │
   ▼
Checkout Source Code
```

The Jenkinsfile also verifies the environment before building:

```text
Node.js
npm
Docker
Trivy
AWS Identity
Kubernetes Cluster
```

This ensures that the Jenkins agent has the required tools and AWS/EKS access before continuing.

---

# 🧪 8. Backend Build & Test

The backend pipeline performs:

```text
npm ci
   │
   ▼
npm run lint
   │
   ▼
npm test
```

`npm ci` installs the exact dependency versions defined by the lock file.

`npm run lint` checks code quality and formatting issues.

`npm test` executes the backend test suite.

If these stages fail, Jenkins stops the pipeline.

---

# 🖥️ 9. Frontend Build

The frontend pipeline performs:

```text
npm ci
   │
   ▼
npm run lint
   │
   ▼
npm run build
```

This validates the frontend source code and produces the production build.

A failed frontend build causes the Jenkins pipeline to fail.

---

# 🔍 10. SonarQube Code Analysis

SonarQube is used for static code analysis.

Jenkins runs the SonarQube Scanner against:

```text
backend/src
frontend/src
```

The scanner sends the source-code analysis data to the SonarQube server.

SonarQube evaluates the project for issues such as:

* Bugs
* Vulnerabilities
* Code smells
* Duplicated code
* Maintainability issues
* Reliability issues

The analysis results are displayed in the SonarQube web interface.

The Jenkins pipeline then waits for the SonarQube Quality Gate.

```text
Jenkins
   │
   │ Source Analysis
   ▼
SonarQube
   │
   ├── Bugs
   ├── Vulnerabilities
   ├── Code Smells
   ├── Coverage / Metrics
   └── Quality Gate
           │
           ▼
      Pass / Fail
```

The Jenkinsfile uses:

```text
waitForQualityGate abortPipeline: true
```

Therefore, a failed Quality Gate prevents the pipeline from proceeding to the Docker build.

---

# 🐳 11. Docker Containerization

The frontend and backend are containerized separately.

## Frontend

The frontend Dockerfile packages the React application into a production Nginx container.

```text
React Source
     │
     ▼
Docker Build
     │
     ▼
Frontend Image
     │
     ▼
Nginx
```

The frontend container is configured to run as a non-root user.

## Backend

The Node.js/Express backend is packaged into its own Docker image.

```text
Node.js Application
        │
        ▼
    Docker Build
        │
        ▼
 Backend Container
```

The backend container also uses non-root execution.

---

# 🛡️ 12. Trivy Security Scan

After Docker images are built, Jenkins runs Trivy before pushing the images to Amazon ECR.

The pipeline scans:

```text
blogapp-backend:<BUILD_NUMBER>
blogapp-frontend:<BUILD_NUMBER>
```

The current Jenkins pipeline scans for:

```text
HIGH
CRITICAL
```

severity vulnerabilities.

Pipeline flow:

```text
Docker Build
     │
     ▼
Trivy Scan
     │
     ├── Backend Image
     │
     └── Frontend Image
     │
     ▼
Amazon ECR Push
```

This places the container vulnerability scan before the registry push.

Trivy is a vulnerability/security scanner capable of scanning container images and other targets.

---

# ☁️ 13. Amazon ECR

Amazon Elastic Container Registry is used as the Docker image registry.

The Jenkins pipeline:

1. Authenticates with ECR
2. Tags the backend image
3. Tags the frontend image
4. Pushes both images to ECR

The repositories are:

```text
blogapp-backend
blogapp-frontend
```

The image tag is generated using the Jenkins:

```text
BUILD_NUMBER
```

For example:

```text
blogapp-backend:35
blogapp-frontend:35
```

The ECR image is then used by Kubernetes during deployment.

---

# ☸️ 14. Amazon EKS

The application is deployed to an Amazon EKS cluster.

The cluster currently contains two worker nodes.

The main application workloads are:

```text
Frontend Deployment
Backend Deployment
MySQL StatefulSet
```

The application uses Kubernetes Services for internal communication.

---

# 🔄 15. Kubernetes Rolling Deployment

Both frontend and backend use Kubernetes `RollingUpdate`.

The current strategy is:

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 1
    maxSurge: 0
```

This configuration was introduced to avoid the additional temporary pod created by:

```text
maxSurge: 1
```

which was causing scheduling pressure on the two-node EKS cluster.

The current backend manifest confirms:

```text
replicas: 2
maxUnavailable: 1
maxSurge: 0
```

The frontend uses the same strategy.

The resulting update behavior is approximately:

```text
Old Replica 1
Old Replica 2

       │
       ▼

Terminate / replace one replica

       │
       ▼

New Replica becomes Ready

       │
       ▼

Replace remaining old replica
```

This avoids creating an additional surge pod during the update.

---

# ❤️ 16. Kubernetes Health Probes

The backend deployment uses both liveness and readiness probes.

## Backend Liveness

```text
/healthz
```

The liveness probe allows Kubernetes to determine whether the application container is still functioning.

## Backend Readiness

```text
/readyz
```

The readiness probe determines whether the backend is ready to receive traffic.

The backend deployment defines these probes together with CPU and memory requests/limits.

The frontend also uses HTTP-based health checks.

---

# 📦 17. Kubernetes Resources

The backend deployment uses:

```text
Replicas: 2

Requests:
  CPU:    100m
  Memory: 256Mi

Limits:
  CPU:    500m
  Memory: 512Mi
```

The frontend also runs with two replicas and defined resource requests and limits.

Resource requests help Kubernetes make scheduling decisions, while limits restrict the maximum resources available to the container.

---

# 🗄️ 18. MySQL StatefulSet

MySQL is deployed using a Kubernetes StatefulSet.

```text
MySQL StatefulSet
       │
       ├── 1 Replica
       │
       ├── MySQL 8.0
       │
       └── Persistent Storage
```

The current configuration uses:

```text
MySQL: 8.0
Replicas: 1
```

The database receives its configuration from a Kubernetes Secret.

The MySQL StatefulSet also defines startup, readiness, and liveness probes using `mysqladmin ping`.

---

# 💾 19. Persistent Storage with AWS EBS

MySQL data is stored on persistent storage rather than relying on the container filesystem.

A custom Kubernetes StorageClass named:

```text
mysql-gp3
```

is used.

The StorageClass uses:

```text
Provisioner:
ebs.csi.aws.com

Volume Type:
gp3

Filesystem:
ext4

Binding Mode:
WaitForFirstConsumer

Reclaim Policy:
Retain
```

The MySQL StatefulSet requests:

```text
10Gi
```

of persistent storage.

Architecture:

```text
MySQL StatefulSet
       │
       ▼
PersistentVolumeClaim
       │
       ▼
AWS EBS CSI Driver
       │
       ▼
GP3 EBS Volume
```

---

# 🔐 20. Kubernetes Secrets

Database credentials are stored using a Kubernetes Secret named:

```text
mysql-secret
```

The backend receives:

```text
DB_USER
DB_PASSWORD
DB_NAME
```

through Kubernetes Secret references.

The backend does not directly hardcode these database credentials in the Deployment manifest.

The MySQL StatefulSet also consumes the database configuration from the Secret.

---

# 🔒 21. Kubernetes NetworkPolicy

A Kubernetes NetworkPolicy is used to restrict access to MySQL.

The policy selects:

```text
app=mysql
```

and permits ingress only from:

```text
app=blogapp-backend
```

on:

```text
TCP 3306
```

Therefore:

```text
Frontend ───────X──────► MySQL
                         ▲
                         │
Backend ────────────────►│
                         │
                       TCP 3306
```

The NetworkPolicy therefore limits database access to backend pods rather than allowing unrestricted pod-to-database traffic.

---

# 👤 22. Non-Root Containers

The application containers are configured to run without root privileges.

This reduces the privileges available to the application process inside the container.

Runtime verification can be performed using:

```bash
kubectl exec <pod-name> -- id
```

The expected result should show the configured non-root user rather than root.

---

# 📊 23. Monitoring

The EKS environment contains a Prometheus/Grafana monitoring stack.

The monitoring components include:

```text
Prometheus
Grafana
Alertmanager
kube-state-metrics
Node Exporter
Prometheus Operator
```

Monitoring provides visibility into:

* Cluster resources
* Node resources
* Pod resources
* Container metrics
* Kubernetes object states
* Workload health

---

# 📈 24. Grafana

Grafana is used to visualize Prometheus metrics.

Dashboards can be used to monitor:

* Kubernetes cluster resources
* Node CPU and memory
* Namespace resources
* Pod resources
* Workloads
* CoreDNS
* Kubernetes components
* Alertmanager

Architecture:

```text
EKS
 │
 ├── Node Exporter
 │
 ├── kube-state-metrics
 │
 └── Application / Kubernetes Metrics
              │
              ▼
         Prometheus
              │
              ▼
           Grafana
```

---

# 🚨 25. Alertmanager

Alertmanager is deployed as part of the monitoring stack.

The general monitoring flow is:

```text
Kubernetes Metrics
       │
       ▼
   Prometheus
       │
       ▼
   Alert Rules
       │
       ▼
  Alertmanager
```

Prometheus evaluates configured alert rules, while Alertmanager handles resulting alerts.

---

# 📝 26. Kubernetes Logging and Troubleshooting

Kubernetes commands are used to troubleshoot application issues.

Useful commands include:

```bash
kubectl get pods -A
```

```bash
kubectl describe pod <pod-name>
```

```bash
kubectl logs <pod-name>
```

```bash
kubectl get events --sort-by='.lastTimestamp'
```

```bash
kubectl get deployments
```

```bash
kubectl get services
```

For deployment troubleshooting:

```bash
kubectl rollout status deployment/blogapp-backend
```

```bash
kubectl rollout status deployment/blogapp-frontend
```

The project specifically used Kubernetes scheduling events to diagnose resource pressure during rolling deployments.

---

# 🔎 27. Deployment Validation

After Jenkins updates the deployments, it waits for the rollout to complete.

Backend:

```bash
kubectl rollout status deployment/blogapp-backend --timeout=5m
```

Frontend:

```bash
kubectl rollout status deployment/blogapp-frontend --timeout=5m
```

The pipeline also verifies:

```bash
kubectl get deployment blogapp-backend
kubectl get deployment blogapp-frontend
kubectl get pods
kubectl get svc
```

The Jenkins pipeline prints the deployed image after updating the deployments.

---

# 🔁 28. Actual Deployment Mechanism

An important part of this project is that deployment is **Jenkins-driven**, not GitOps-driven.

The Jenkins pipeline executes:

```text
kubectl set image deployment/blogapp-backend
```

and:

```text
kubectl set image deployment/blogapp-frontend
```

using the newly generated Jenkins build number.

The actual flow is therefore:

```text
GitHub
   │
   ▼
Jenkins
   │
   ├── Build
   ├── Test
   ├── SonarQube
   ├── Quality Gate
   ├── Docker Build
   ├── Trivy
   └── ECR Push
          │
          ▼
      kubectl set image
          │
          ▼
        EKS
```

There is currently **no Argo CD synchronization step** in this workflow.

---

# 🔐 29. Security Controls

The project incorporates security controls at multiple layers.

## Source Code

* GitHub source control
* SonarQube static analysis
* SonarQube Quality Gate

## Container Security

* Non-root containers
* Trivy vulnerability scanning
* Separate frontend/backend images

## AWS

* IAM-based authentication
* Amazon ECR authentication
* EKS IAM integration

## Kubernetes

* Kubernetes Secrets
* NetworkPolicy
* Resource limits
* Health probes
* Non-root workloads

---

# 🧩 30. Why Amazon ECR Instead of Nexus?

Amazon ECR is the image registry used by this project.

The actual pipeline is:

```text
Docker Build
     │
     ▼
Trivy Scan
     │
     ▼
ECR Login
     │
     ▼
Docker Tag
     │
     ▼
Docker Push
     │
     ▼
Amazon ECR
```

There is **no Nexus Repository stage**.

Nexus is therefore intentionally **not part of the technology stack or architecture of this implementation**.

---

# ⚙️ 31. Jenkins Pipeline Stages

The Jenkinsfile currently contains the following major stages:

```text
1. Checkout
2. Verify Environment
3. Backend Build & Test
4. Frontend Build
5. SonarQube Analysis
6. SonarQube Quality Gate
7. Docker Build
8. Trivy Security Scan
9. ECR Push
10. EKS Deployment
```

The pipeline uses the Jenkins `BUILD_NUMBER` to version the Docker images.

For example:

```text
Build #35

blogapp-backend:35
blogapp-frontend:35
```

---

# 🏆 32. End-to-End Workflow

The complete project workflow is:

```text
                         Developer
                             │
                             ▼
                          GitHub
                             │
                         Webhook
                             │
                             ▼
                         Jenkins
                             │
                             ▼
                    Checkout Source Code
                             │
                             ▼
                    Verify Environment
                             │
                 ┌───────────┴───────────┐
                 ▼                       ▼
          Backend Build             Frontend Build
                 │                       │
          npm ci / lint / test     npm ci / lint / build
                 │                       │
                 └───────────┬───────────┘
                             ▼
                        SonarQube
                             │
                             ▼
                       Quality Gate
                             │
                       Pass / Fail
                             │
                             ▼
                       Docker Build
                             │
                             ▼
                       Trivy Scan
                             │
                             ▼
                        Amazon ECR
                             │
                             ▼
                     Amazon EKS
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
          Frontend        Backend         MySQL
          2 replicas      2 replicas      StatefulSet
                                             │
                                             ▼
                                        EBS Storage
                             │
                             ▼
                      Prometheus / Grafana
                             │
                             ▼
                        Monitoring
```

---

# 📋 33. Project Components Summary

| Component             | Purpose                                                  |
| --------------------- | -------------------------------------------------------- |
| GitHub                | Source code and configuration management                 |
| Jenkins               | CI/CD automation                                         |
| SonarQube             | Static code analysis                                     |
| Quality Gate          | Controls pipeline progression based on SonarQube results |
| Docker                | Application containerization                             |
| Trivy                 | Container vulnerability scanning                         |
| Amazon ECR            | Docker image registry                                    |
| Amazon EKS            | Kubernetes platform                                      |
| Kubernetes Deployment | Frontend/backend workload management                     |
| Kubernetes Service    | Internal service discovery                               |
| MySQL StatefulSet     | Database workload                                        |
| Kubernetes Secret     | Database credentials                                     |
| NetworkPolicy         | Database network isolation                               |
| AWS EBS CSI           | Persistent database storage                              |
| Prometheus            | Metrics collection                                       |
| Grafana               | Metrics visualization                                    |
| Alertmanager          | Alert management                                         |
| kube-state-metrics    | Kubernetes object metrics                                |
| Node Exporter         | Node-level metrics                                       |

---

# 🧪 34. Validation Commands

Check nodes:

```bash
kubectl get nodes -o wide
```

Check all application pods:

```bash
kubectl get pods -o wide
```

Check deployments:

```bash
kubectl get deployments
```

Check services:

```bash
kubectl get svc
```

Check backend rollout:

```bash
kubectl rollout status deployment/blogapp-backend --timeout=5m
```

Check frontend rollout:

```bash
kubectl rollout status deployment/blogapp-frontend --timeout=5m
```

Check backend image:

```bash
kubectl get deployment blogapp-backend \
  -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
```

Check frontend image:

```bash
kubectl get deployment blogapp-frontend \
  -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
```

Check events:

```bash
kubectl get events --sort-by='.lastTimestamp'
```

Check application logs:

```bash
kubectl logs <pod-name>
```

Check container user:

```bash
kubectl exec <pod-name> -- id
```

---

# 📌 35. Key DevOps Concepts Demonstrated

This project demonstrates practical experience with:

### CI/CD

* Jenkins Declarative Pipeline
* Automated builds
* Automated testing
* Automated security scanning
* Automated Docker image publishing
* Automated Kubernetes deployment

### DevSecOps

* SonarQube
* Quality Gates
* Trivy
* Non-root containers
* Kubernetes Secrets
* NetworkPolicy

### Kubernetes

* Deployments
* Services
* StatefulSets
* ConfigMaps
* Secrets
* Probes
* Resource requests/limits
* RollingUpdate
* PersistentVolumeClaims
* StorageClasses
* NetworkPolicy

### AWS

* Amazon EKS
* Amazon ECR
* AWS EBS
* EBS CSI Driver
* IAM
* AWS networking

### Monitoring

* Prometheus
* Grafana
* Alertmanager
* Node Exporter
* kube-state-metrics

---

# ⚠️ 36. Important Architecture Note

This project should be described accurately as a:

> **Jenkins-based CI/CD and DevSecOps deployment to Amazon EKS**

It should **not** be described as:

* Nexus-based artifact management
* Argo CD GitOps deployment
* Helm-based deployment
* GitOps manifest update workflow

Those technologies are not part of the current implemented pipeline.

The current deployment mechanism is:

```text
Jenkins
   │
   ├── Build
   ├── Test
   ├── SonarQube
   ├── Quality Gate
   ├── Docker
   ├── Trivy
   ├── ECR
   │
   └── kubectl set image
              │
              ▼
             EKS
```

---

# 🎯 37. Project Outcome

The project demonstrates an end-to-end DevOps workflow in which application code moves from GitHub through automated CI/CD and security validation before being deployed to Amazon EKS.

The final implementation includes:

```text
Source Control
      ↓
CI Automation
      ↓
Code Quality
      ↓
Quality Gate
      ↓
Containerization
      ↓
Security Scanning
      ↓
Container Registry
      ↓
Kubernetes Deployment
      ↓
Rolling Update
      ↓
Persistent Database
      ↓
Network Isolation
      ↓
Monitoring & Alerting
```

The implementation focuses on demonstrating practical DevOps, Kubernetes, AWS, CI/CD, and DevSecOps concepts using a complete three-tier application.
