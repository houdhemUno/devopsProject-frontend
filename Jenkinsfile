pipeline {
    agent any

    environment {
        // Define environment variables here
        NEXUS_REPO = 'http://your-nexus-repo/repository/npm-releases/'
        DOCKER_REGISTRY = 'your-docker-registry'
        K8S_NAMESPACE = 'your-kubernetes-namespace'
    }
    tools{
        nodejs "NodeJsInstallation"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout source code
                checkout scm
                echo 'checkout suc'
            }
        }

        stage('Build and Test') {
            steps {
                    sh 'npm install'
                    sh 'npm run build'
                    sh 'ls'
            }
        }

        stage('SonarQube Analysis') {
            steps{
                script {
                    def scannerHome = tool 'sonarQube-scanner-sample'; 
                    echo ' trying hard'
                    withSonarQubeEnv('sonarQube-installation') {
                        echo "starting scan "
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

        stage('Save Artifact to Nexus') {
            steps {
                script {
                    sh 'tar -czf frontend-artifact.tgz dist/*'
                    sh "curl -v --user admin:9e4b183d-303f-4bda-9706-121c900c117b --upload-file frontend-artifact.tgz -H "Content-Type: application/octet-stream" http://iac-nexus-1:8081/repository/webAppArtifact/frontend-artifact-1.tgz"
                }
            }
        }

        // stage('Build and Push Docker Image') {
        //     steps {
        //         script {
        //             // Build Docker image for the backend
        //             sh 'docker build -t $DOCKER_REGISTRY/your-node-app:${BUILD_NUMBER} ./backend'

        //             // Push Docker image to registry
        //             sh 'docker push $DOCKER_REGISTRY/your-node-app:${BUILD_NUMBER}'
        //         }
        //     }
        // }

        // stage('Deploy on Kubernetes') {
        //     steps {
        //         script {
        //             // Assuming you have Kubernetes credentials configured in Jenkins
        //             withKubeConfig([credentialsId: 'your-kube-config-credentials', serverUrl: 'https://your-kube-api-server']) {
        //                 sh "kubectl apply -f kubernetes-deployment.yaml --namespace=${K8S_NAMESPACE}"
        //             }
        //         }
        //     }
        // }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
