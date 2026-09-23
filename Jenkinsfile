
pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Environment') {
            steps {
                sh '''
                    echo "=== Jenkins Shell ==="
                    echo "PATH=$PATH"
                    whoami
                    pwd

                    echo "=== Node ==="
                    command -v node
                    node --version

                    echo "=== npm ==="
                    command -v npm
                    npm --version

                    echo "=== Docker ==="
                    docker --version

                    echo "=== Trivy ==="
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
                        echo "=== Installing backend dependencies ==="
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
                        echo "=== Installing frontend dependencies ==="
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
                script {
                    def scannerHome = tool 'SonarQubeCLI'

                    withSonarQubeEnv('SonarQube') {
                        sh """
                            echo "=== SonarQube Analysis ==="
                            ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=BlogReact \
                                -Dsonar.projectName=BlogReact \
                                -Dsonar.sources=backend/src,frontend/src \
                                -Dsonar.sourceEncoding=UTF-8
                        """
                    }
                }
            }
        }

        stage('SonarQube Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
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

                    echo "=== Docker Images Created ==="
                    docker images | grep -E "blogapp-backend|blogapp-frontend"
                '''
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh '''
                    echo "=== Trivy Version ==="
                    trivy --version

                    echo "=== Trivy Backend Image Scan ==="
                    trivy image \
                        --severity HIGH,CRITICAL \
                        blogapp-backend:${BUILD_NUMBER}

                    echo "=== Trivy Frontend Image Scan ==="
                    trivy image \
                        --severity HIGH,CRITICAL \
                        blogapp-frontend:${BUILD_NUMBER}
                '''
            }
        }

        stage('ECR Push') {
            steps {
                sh '''
                    echo "=== AWS Account ==="
                    aws sts get-caller-identity

                    echo "=== ECR Login ==="
                    aws ecr get-login-password --region ap-south-1 | \
                        docker login \
                        --username AWS \
                        --password-stdin \
                        382170164329.dkr.ecr.ap-south-1.amazonaws.com

                    echo "=== Tagging Backend Image ==="
                    docker tag \
                        blogapp-backend:${BUILD_NUMBER} \
                        382170164329.dkr.ecr.ap-south-1.amazonaws.com/blogapp-backend:${BUILD_NUMBER}

                    echo "=== Tagging Frontend Image ==="
                    docker tag \
                        blogapp-frontend:${BUILD_NUMBER} \
                        382170164329.dkr.ecr.ap-south-1.amazonaws.com/blogapp-frontend:${BUILD_NUMBER}

                    echo "=== Pushing Backend Image ==="
                    docker push \
                        382170164329.dkr.ecr.ap-south-1.amazonaws.com/blogapp-backend:${BUILD_NUMBER}

                    echo "=== Pushing Frontend Image ==="
                    docker push \
                        382170164329.dkr.ecr.ap-south-1.amazonaws.com/blogapp-frontend:${BUILD_NUMBER}

                    echo "=== ECR Push Completed ==="
                '''
            }
        }
    }
}

