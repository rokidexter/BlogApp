# Production-Level Three-Tier Blog Application CI/CD Deployment on Amazon EKS

A production-oriented DevOps implementation of a three-tier Blog Application deployed on **Amazon Elastic Kubernetes Service (EKS)** with an automated **CI/CD and DevSecOps pipeline**.

The project demonstrates containerization, Kubernetes orchestration, automated CI/CD, code-quality analysis, vulnerability scanning, artifact management, monitoring, logging, networking controls, secrets management, and security practices.

---

## 🚀 Project Overview

This project takes a full-stack Blog Application and deploys it as a containerized three-tier application on Amazon EKS.

The application consists of:

* **Frontend** — React-based web application
* **Backend** — Node.js/Express REST API
* **Database** — MySQL

The deployment is automated through a Jenkins-based CI/CD pipeline.

The overall workflow is:

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
    ├── SonarQube Analysis
    ├── Build & Test
    ├── Docker Build
    ├── Trivy Security Scan
    ├── Nexus Artifact Management
    └── Deploy to Amazon EKS
             │
             ▼
        Amazon EKS
        ┌───────────────┐
        │   Frontend    │
        │   React/Nginx │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │    Backend    │
        │ Node.js/API   │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │     MySQL     │
        └───────────────┘

        Monitoring
        ┌────────────────────┐
        │ Prometheus         │
        │ Grafana            │
        │ Alertmanager       │
        │ Node Exporter      │
        │ kube-state-metrics │
        └────────────────────┘
```

---

# 📌 Project Objectives

The main objectives of this project were to implement a production-oriented DevOps workflow covering:

* Source code management
* CI/CD automation
* Docker containerization
* Container image management
* Kubernetes deployment
* Amazon EKS orchestration
* Infrastructure and workload security
* Static code analysis
* Container vulnerability scanning
* Artifact management
* Application monitoring
* Kubernetes monitoring
* Centralized/Kubernetes-based logging
* Secure secret management
* Network isolation
* Production-oriented deployment practices

---

# 🏗️ Architecture

```text
                         ┌─────────────────┐
                         │     GitHub      │
                         │ Source Control  │
                         └────────┬────────┘
                                  │
                                  ▼
                         ┌─────────────────┐
                         │     Jenkins     │
                         │   CI/CD Server  │
                         └────────┬────────┘
                                  │
              ┌──────────────────┼──────────────────┐
              │                  │                  │
              ▼                  ▼                  ▼
         SonarQube             Trivy             Nexus
        Code Quality       Security Scan      Artifact Mgmt
              │                  │                  │
              └──────────────────┼──────────────────┘
                                 │
                                 ▼
                         ┌─────────────────┐
                         │  Amazon ECR     │
                         │ Container Image │
                         │    Registry     │
                         └────────┬────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │      Amazon EKS         │
                    │                         │
                    │ ┌─────────────────────┐ │
                    │ │ Frontend Deployment │ │
                    │ │ React + Nginx       │ │
                    │ └──────────┬──────────┘ │
                    │            │             │
                    │            ▼             │
                    │ ┌─────────────────────┐ │
                    │ │ Backend Deployment  │ │
                    │ │ Node.js / Express   │ │
                    │ └──────────┬──────────┘ │
                    │            │             │
                    │            ▼             │
                    │ ┌─────────────────────┐ │
                    │ │ MySQL StatefulSet   │ │
                    │ └─────────────────────┘ │
                    │                         │
                    └────────────┬────────────┘
                                 │
                  ┌──────────────┴──────────────┐
                  │                             │
                  ▼                             ▼
          ┌───────────────┐             ┌───────────────┐
          │  Prometheus   │             │    Grafana    │
          │   Monitoring  │             │ Visualization │
          └───────────────┘             └───────────────┘
```

---

# 🧰 Technology Stack

## Application

| Layer         | Technology |
| ------------- | ---------- |
| Frontend      | React      |
| Web Server    | Nginx      |
| Backend       | Node.js    |
| API Framework | Express.js |
| Database      | MySQL      |

## DevOps

| Area                  | Technology         |
| --------------------- | ------------------ |
| Source Control        | Git / GitHub       |
| CI/CD                 | Jenkins            |
| Containerization      | Docker             |
| Container Registry    | Amazon ECR         |
| Kubernetes            | Amazon EKS         |
| Cloud                 | AWS                |
| Code Quality          | SonarQube          |
| Vulnerability Scanner | Trivy              |
| Artifact Repository   | Nexus              |
| Monitoring            | Prometheus         |
| Visualization         | Grafana            |
| Alerting              | Alertmanager       |
| Kubernetes Metrics    | kube-state-metrics |
| Node Metrics          | Node Exporter      |

---

# 📁 Project Structure

A simplified structure of the project is:

```text
BlogReact/
│
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   └── src/
│
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── ...
│
├── k8s/
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── mysql-statefulset.yaml
│   ├── mysql-service.yaml
│   ├── mysql-secret.yaml
│   └── network-policy.yaml
│
├── Jenkinsfile
├── Dockerfile
├── README.md
└── ...
```

> The exact directory structure can vary according to the final repository state.

---

# 🔄 CI/CD Pipeline

The Jenkins pipeline automates the application delivery process.

```text
GitHub
   │
   ▼
Checkout
   │
   ▼
SonarQube Analysis
   │
   ▼
Build & Test
   │
   ▼
Docker Build
   │
   ▼
Trivy Scan
   │
   ▼
Nexus / Artifact Handling
   │
   ▼
Amazon ECR
   │
   ▼
Amazon EKS
   │
   ▼
Deployment Validation
   │
   ▼
Monitoring
```

---

# 1️⃣ Source Code Management

GitHub is used as the source-code repository.

The repository provides version control for:

* Frontend source code
* Backend source code
* Dockerfiles
* Kubernetes manifests
* Jenkins pipeline configuration
* Configuration files
* Documentation

Example:

```bash
git clone <repository-url>
cd BlogReact
```

---

# 2️⃣ Jenkins CI/CD

Jenkins acts as the automation engine for the project.

The pipeline is responsible for automating the build, testing, security, packaging, and deployment workflow.

Typical stages include:

```text
Checkout
    ↓
SonarQube
    ↓
Build & Test
    ↓
Docker Build
    ↓
Trivy Scan
    ↓
Push Image
    ↓
Deploy to EKS
    ↓
Validation
```

This reduces manual deployment steps and provides a repeatable application delivery process.

---

# 3️⃣ SonarQube Code Quality

SonarQube is integrated into the CI pipeline for static code analysis.

The purpose of SonarQube is to identify issues such as:

* Bugs
* Vulnerabilities
* Code smells
* Duplicated code
* Maintainability issues
* Reliability issues

The Jenkins pipeline sends the source code to SonarQube for analysis.

The SonarQube server performs the analysis and displays the results through its web interface.

A Quality Gate can then be used to determine whether the code meets the configured quality requirements.

```text
Jenkins
   │
   │ Source Code
   ▼
SonarQube
   │
   ├── Bugs
   ├── Vulnerabilities
   ├── Code Smells
   ├── Coverage
   └── Quality Gate
```

---

# 4️⃣ Docker Containerization

The application components are containerized independently.

## Frontend

The frontend uses a multi-stage Docker build:

```text
Node.js
   ↓
Build React Application
   ↓
Nginx
   ↓
Production Container
```

The production frontend container runs using the non-root `nginx` user.

## Backend

The backend is packaged into a Node.js production container.

The production container runs using the non-root `nodeuser` user.

This reduces the privileges available to the application process inside the container.

---

# 5️⃣ Amazon ECR

Amazon Elastic Container Registry is used to store Docker images.

The pipeline builds the application images and pushes them to ECR.

Example workflow:

```text
Docker Build
     ↓
Docker Tag
     ↓
ECR Login
     ↓
Docker Push
     ↓
Amazon ECR
```

Images can then be pulled by the EKS workloads during deployment.

---

# 6️⃣ Trivy Security Scanning

Trivy is integrated into the CI/CD workflow to scan container images for vulnerabilities.

Example:

```bash
trivy image <image-name>
```

The scan can identify vulnerabilities in:

* Operating system packages
* Application dependencies
* Container images

This provides an additional security validation step before deployment.

---

# 7️⃣ Nexus Repository

Nexus is used as part of the artifact-management workflow.

It provides centralized storage and management of build artifacts and packages.

The general DevOps flow is:

```text
Build
  ↓
Artifact
  ↓
Nexus
  ↓
Deployment Pipeline
```

---

# 8️⃣ Amazon EKS Deployment

The application is deployed to an Amazon EKS cluster.

The Kubernetes workloads include:

```text
Frontend Deployment
Frontend Service

Backend Deployment
Backend Service

MySQL StatefulSet
MySQL Service
```

The application workloads were verified using:

```bash
kubectl get pods -A
```

The deployed environment contains separate frontend and backend replicas along with the MySQL workload.

---

# 9️⃣ Kubernetes Services

Kubernetes Services provide stable networking between workloads.

The application follows:

```text
Frontend
   │
   ▼
Backend Service
   │
   ▼
MySQL Service
```

The backend communicates with MySQL using the Kubernetes service rather than directly depending on a pod IP.

---

# 🔐 10️⃣ Secrets Management

Sensitive configuration such as database credentials is handled using Kubernetes Secrets rather than hardcoding credentials directly into application source code.

The application consumes secret values through Kubernetes configuration.

Example concept:

```text
Kubernetes Secret
       │
       ▼
Backend Pod
       │
       ▼
Database Connection
```

Secret values should never be committed to GitHub.

---

# 🔒 11️⃣ Kubernetes NetworkPolicy

A Kubernetes NetworkPolicy was implemented to restrict database access.

The MySQL NetworkPolicy:

```text
Pod Selector:
app=mysql

Allowed Source:
app=blogapp-backend

Allowed Port:
TCP 3306
```

Therefore:

```text
Frontend ─────X─────> MySQL

Backend ────────────> MySQL :3306
```

This provides network-level isolation for the database workload.

---

# 🛡️ 12️⃣ Kubernetes RBAC

Kubernetes RBAC provides authorization controls for Kubernetes resources.

The project environment contains Kubernetes:

* Roles
* RoleBindings
* ClusterRoles
* ClusterRoleBindings

RBAC is used by Kubernetes components and monitoring components to obtain the permissions required for their operation.

The final environment was also inspected using:

```bash
kubectl auth whoami
kubectl auth can-i <verb> <resource>
```

---

# 👤 13️⃣ Non-Root Containers

Both application containers were configured to run as non-root users.

## Backend

```dockerfile
USER nodeuser
```

## Frontend

```dockerfile
USER nginx
```

This reduces the privileges available to the processes inside the containers.

Runtime verification can be performed with:

```bash
kubectl exec <pod-name> -- id
```

---

# 📊 14️⃣ Monitoring

The project implements Kubernetes monitoring using the Prometheus and Grafana ecosystem.

Monitoring components include:

* Prometheus
* Grafana
* Alertmanager
* kube-state-metrics
* Node Exporter
* Prometheus Operator

The monitoring stack collects and visualizes:

* Kubernetes cluster metrics
* Node metrics
* Pod metrics
* Container metrics
* Kubernetes object state
* Application-related infrastructure metrics

---

# 📈 Grafana Dashboards

Grafana was configured with Kubernetes monitoring dashboards.

Available dashboards include:

* Kubernetes / API Server
* Kubernetes / Compute Resources / Cluster
* Kubernetes / Compute Resources / Namespace
* Kubernetes / Compute Resources / Workloads
* CoreDNS
* etcd
* Grafana Overview
* Alertmanager Overview

Example access:

```text
http://<EC2-PUBLIC-IP>:3000
```

---

# 🚨 15️⃣ Alerting

Alertmanager is deployed as part of the monitoring stack.

It works with Prometheus to handle configured alert rules.

The architecture is:

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

---

# 📝 16️⃣ Logging

Kubernetes-based application logging is used to troubleshoot application and deployment issues.

Logs can be inspected using:

```bash
kubectl logs <pod-name>
```

For example:

```bash
kubectl logs <backend-pod>
kubectl logs <frontend-pod>
kubectl logs <mysql-pod>
```

Kubernetes workload information can also be inspected using:

```bash
kubectl describe pod <pod-name>
kubectl get events
```

The logging workflow allows identification of:

* Application errors
* Container startup failures
* Configuration problems
* Deployment issues
* Database connection problems
* Kubernetes scheduling/runtime issues

---

# 🔐 17️⃣ Security Controls

The project demonstrates several production-oriented security controls.

### AWS

* IAM-based authentication
* EKS IAM integration
* EC2 IAM role
* ECR authentication

### Kubernetes

* RBAC
* NetworkPolicy
* Kubernetes Secrets
* Restricted database ingress
* Workload-level access control

### Containers

* Non-root execution
* Trivy vulnerability scanning
* Minimal Alpine-based production images

### Source Code

* Credentials are not intentionally stored in source code
* Secrets are managed separately from application source
* CI/CD security checks are incorporated into the pipeline

---

# ⚠️ IAM Security Note

The current development environment uses the EC2 role:

```text
Project04-DevOps-EC2-Role
```

The role currently has broad AWS permissions, including:

```text
AdministratorAccess
PowerUserAccess
```

The EKS access entry also currently uses:

```text
AmazonEKSClusterAdminPolicy
```

with cluster-wide scope.

These permissions were used to operate and troubleshoot the development environment.

For a production environment, these should be replaced with narrowly scoped IAM and EKS permissions based on the exact requirements of Jenkins and the deployment workflow.

This distinction is important: **the project demonstrates security controls, but the current Jenkins/EC2 role is not a least-privilege configuration.**

---

# 🩺 18️⃣ Health Checks

The application workloads can be validated using Kubernetes commands such as:

```bash
kubectl get pods
```

```bash
kubectl get deployments
```

```bash
kubectl get services
```

```bash
kubectl describe pod <pod-name>
```

The application deployment uses Kubernetes health-check mechanisms where configured to help Kubernetes determine workload health.

---

# 🔄 19️⃣ Deployment Validation

After deployment, the environment can be validated using:

```bash
kubectl get pods -A
```

```bash
kubectl get svc -A
```

```bash
kubectl get deployments -A
```

```bash
kubectl get nodes
```

A successful deployment should show the application pods in a healthy `Running` state.

---

# 🧪 20️⃣ Troubleshooting Workflow

A basic troubleshooting workflow is:

```text
Application Issue
       │
       ▼
Check Pods
       │
       ▼
Check Pod Events
       │
       ▼
Check Container Logs
       │
       ▼
Check Service
       │
       ▼
Check NetworkPolicy
       │
       ▼
Check Configuration / Secrets
       │
       ▼
Check Application Dependencies
```

Useful commands:

```bash
kubectl get pods -A
```

```bash
kubectl logs <pod-name>
```

```bash
kubectl describe pod <pod-name>
```

```bash
kubectl get svc
```

```bash
kubectl get networkpolicy
```

```bash
kubectl get events --sort-by=.lastTimestamp
```

---

# 🌐 21️⃣ Application Access

The deployed application is exposed through the AWS load-balancing/Kubernetes service configuration.

### Application

```text
http://<APPLICATION-LOAD-BALANCER-URL>
```

Replace the placeholder with the currently active AWS Load Balancer DNS name.

> Do not hard-code an ephemeral load-balancer URL in the README if the infrastructure may be recreated.

---

# 🔗 22️⃣ Repository

### GitHub

The repository containing the project source code and DevOps configuration:

```text
https://github.com/Vennilavanguvi/BlogReact
```

---

# 📋 23️⃣ Project Deliverables

This project covers the following DevOps capabilities:

| Capability              | Implementation                                   |
| ----------------------- | ------------------------------------------------ |
| Source Control          | Git / GitHub                                     |
| CI/CD                   | Jenkins                                          |
| Code Quality            | SonarQube                                        |
| Containerization        | Docker                                           |
| Image Registry          | Amazon ECR                                       |
| Artifact Management     | Nexus                                            |
| Vulnerability Scanning  | Trivy                                            |
| Container Orchestration | Kubernetes                                       |
| Managed Kubernetes      | Amazon EKS                                       |
| Networking              | Kubernetes Services / NetworkPolicy              |
| Secrets                 | Kubernetes Secrets                               |
| Authorization           | Kubernetes RBAC                                  |
| Monitoring              | Prometheus                                       |
| Visualization           | Grafana                                          |
| Alerting                | Alertmanager                                     |
| Kubernetes Metrics      | kube-state-metrics                               |
| Node Metrics            | Node Exporter                                    |
| Logging                 | Kubernetes logs / events                         |
| Security                | IAM / RBAC / NetworkPolicy / non-root containers |

---

# 🎯 24️⃣ Key DevOps Concepts Demonstrated

Through this project, the following concepts were implemented and practiced:

* CI/CD pipeline design
* Jenkins declarative pipelines
* Git-based workflow
* Docker multi-stage builds
* Container image versioning
* Amazon ECR
* Kubernetes Deployments
* Kubernetes Services
* StatefulSets
* ConfigMaps
* Secrets
* Kubernetes RBAC
* NetworkPolicies
* Amazon EKS
* SonarQube
* Quality Gates
* Trivy
* Nexus
* Prometheus
* Grafana
* Alertmanager
* Kubernetes monitoring
* Application logging
* Container security
* IAM
* AWS networking
* Production deployment validation
* DevSecOps principles

---

# 🏁 Conclusion

This project demonstrates an end-to-end DevOps and DevSecOps workflow for deploying a three-tier Blog Application on Amazon EKS.

The implementation combines:

```text
GitHub
   ↓
Jenkins
   ↓
SonarQube
   ↓
Build & Test
   ↓
Docker
   ↓
Trivy
   ↓
Nexus / ECR
   ↓
Amazon EKS
   ↓
Kubernetes
   ↓
Prometheus + Grafana
   ↓
Logging + Security
```

The project provides practical experience with application deployment, Kubernetes orchestration, CI/CD automation, container security, cloud infrastructure, observability, and production-oriented DevOps practices.

---

## 👨‍💻 Author

**Rokith Kumar**

DevOps / Cloud / Infrastructure Engineering

Skills demonstrated:

`AWS` `EKS` `Kubernetes` `Docker` `Jenkins` `Git` `GitHub` `Terraform` `SonarQube` `Trivy` `Nexus` `Prometheus` `Grafana` `Linux` `CI/CD` `DevSecOps`
