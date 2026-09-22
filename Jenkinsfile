
pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    echo "=== Repository ==="
                    git remote -v

                    echo "=== Latest Commit ==="
                    git log -1 --oneline

                    echo "=== Docker ==="
                    docker --version

                    echo "=== AWS Identity ==="
                    aws sts get-caller-identity

                    echo "=== Kubernetes Nodes ==="
                    kubectl get nodes

                    echo "=== Project Files ==="
                    ls -la
                '''
            }
        }
    }
}

