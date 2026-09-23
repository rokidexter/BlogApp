
pipeline {

    agent any

    environment {
        AWS_REGION = 'ap-south-1'

        BACKEND_IMAGE = '382170164329.dkr.ecr.ap-south-1.amazonaws.com/blogapp-backend'
        FRONTEND_IMAGE = '382170164329.dkr.ecr.ap-south-1.amazonaws.com/blogapp-frontend'
    }

    stages {

        stage('Checkout') {
            steps {
                echo '=== Checking out source code ==='
                checkout scm
            }
        }

        stage('Verify Environment') {
            steps {
                sh '''
                    echo "=== Node Version ==="
                    node --version

                    echo "=== NPM Version ==="
                    npm --version

                    echo "=== Docker Version ==="
                    docker --version

                    echo "=== Trivy Version ==="
                    trivy --version

                    echo "=== AWS Identity ==="
                    aws sts get-caller-identity

                    echo "=== Kubernetes Nodes ==="
                    kubectl get nodes
                '''
            }
        }

        stage('Backend Build & Test') {
            steps {
                dir('backend') {
                    sh '''
                        echo "=== Installing Backend Dependencies ==="
                        npm ci

                        echo "=== Backend Lint ==="
                        npm run lint

                        echo "=== Backend Tests ==="
                        npm test
                    '''
                }
            }
        }

        stage('Frontend Build') {
            steps {
                dir('frontend') {
                    sh '''
                        echo "=== Installing Frontend Dependencies ==="
                        npm ci

                        echo "=== Frontend Lint ==="
                        npm run lint

                        echo "=== Frontend Build ==="
                        npm run build
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        echo "=== SonarQube Analysis ==="
                        sonar-scanner \
                            -Dsonar.projectKey=BlogReact \
                            -Dsonar.projectName=BlogReact \
                            -Dsonar.sources=backend/src,frontend/src \
                            -Dsonar.host.url=http://localhost:9000
                    '''
                }
            }
        }

        stage('SonarQube Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "=== Building Backend Docker Image ==="
                    docker build \
                        -t blogapp-backend:${BUILD_NUMBER} \
                        ./backend

                    echo "=== Building Frontend Docker Image ==="
                    docker build \
                        -t blogapp-frontend:${BUILD_NUMBER} \
                        ./frontend

                    echo "=== Docker Images ==="
                    docker images | grep blogapp
                '''
            }
        }

        // Trivy performs container image vulnerability scanning.
        // It checks the Docker images for known HIGH and CRITICAL vulnerabilities.
        // The scan runs after Docker image creation and before pushing images to ECR.
        stage('Trivy Security Scan') {
            steps {
                sh '''
                    echo "=== Trivy Version ==="
                    trivy --version

                    echo "=== Scanning Backend Image ==="
                    trivy image \
                        --severity HIGH,CRITICAL \
                        blogapp-backend:${BUILD_NUMBER}

                    echo "=== Scanning Frontend Image ==="
                    trivy image \
                        --severity HIGH,CRITICAL \
                        blogapp-frontend:${BUILD_NUMBER}
                '''
            }
        }

        stage('ECR Push') {
            steps {
                sh '''
                    echo "=== ECR Login ==="

                    aws ecr get-login-password \
                        --region ${AWS_REGION} | \
                    docker login \
                        --username AWS \
                        --password-stdin \
                        382170164329.dkr.ecr.ap-south-1.amazonaws.com

                    echo "=== Tagging Backend Image ==="

                    docker tag \
                        blogapp-backend:${BUILD_NUMBER} \
                        ${BACKEND_IMAGE}:${BUILD_NUMBER}

                    echo "=== Tagging Frontend Image ==="

                    docker tag \
                        blogapp-frontend:${BUILD_NUMBER} \
                        ${FRONTEND_IMAGE}:${BUILD_NUMBER}

                    echo "=== Pushing Backend Image ==="

                    docker push \
                        ${BACKEND_IMAGE}:${BUILD_NUMBER}

                    echo "=== Pushing Frontend Image ==="

                    docker push \
                        ${FRONTEND_IMAGE}:${BUILD_NUMBER}

                    echo "=== ECR Push Completed ==="
                '''
            }
        }

        stage('EKS Deployment') {
            steps {
                sh '''
                    echo "=== EKS Cluster ==="
                    kubectl config current-context

                    echo "=== Updating Backend Deployment ==="

                    kubectl set image deployment/blogapp-backend \
                        backend=${BACKEND_IMAGE}:${BUILD_NUMBER}

                    echo "=== Updating Frontend Deployment ==="

                    kubectl set image deployment/blogapp-frontend \
                        frontend=${FRONTEND_IMAGE}:${BUILD_NUMBER}

                    echo "=== Waiting for Backend Rollout ==="

                    kubectl rollout status deployment/blogapp-backend \
                        --timeout=5m

                    echo "=== Waiting for Frontend Rollout ==="

                    kubectl rollout status deployment/blogapp-frontend \
                        --timeout=5m

                    echo "=== Backend Image ==="

                    kubectl get deployment blogapp-backend \
                        -o jsonpath='{.spec.template.spec.containers[0].image}{"\\n"}'

                    echo "=== Frontend Image ==="

                    kubectl get deployment blogapp-frontend \
                        -o jsonpath='{.spec.template.spec.containers[0].image}{"\\n"}'

                    echo "=== Running Pods ==="

                    kubectl get pods

                    echo "=== Services ==="

                    kubectl get svc

                    echo "=== EKS Deployment Completed ==="
                '''
            }
        }
    }

    post {
        success {
            echo '=== CI/CD Pipeline Completed Successfully ==='
        }

        failure {
            echo '=== CI/CD Pipeline Failed ==='
        }
    }
}

