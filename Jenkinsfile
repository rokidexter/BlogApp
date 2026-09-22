```groovy
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
    }
}
```
