pipeline {
    agent any

    environment {
        // Define environment variables here
        NEXUS_URL = 'iac-nexus-1:8081'
        NEXUS_REPO = 'front-repo'
        NEXUS_CREDENTIALS_ID = 'nexus-credentials'
        DOCKER_REGISTRY = 'houdhemassoudi/devops-front'
        DOCKER_CRED = credentials('docker-cred')
        K8S_NAMESPACE = 'your-kubernetes-namespace'
    }
    tools{
        nodejs "NodeJsInstallation"
        dockerTool "dockerInstall"
    
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
                    sh 'npm -v'
                    //Install the Node.js application
                    sh 'npm install'
                    //Build the Node.js application
                    sh 'npm run build'
                    //Package the Node.js application
                    sh 'npm pack'
                    //Check folder
                    sh 'ls'
            }
        }

        stage('SonarQube Analysis') {
            steps{
                script {
                    def scannerHome = tool 'SonarQubeScannerInstall'; 
                    echo ' trying hard'
                    withSonarQubeEnv('sonarInstall') {
                        echo "starting scan "
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

        stage('Save Artifact to Nexus') {
            steps {
                script {
                    // sh 'tar -czf frontend-artifact.tgz dist/*'
                    // sh "curl -v --user admin:51b5b124-b893-427d-a631-96e00804a386 --upload-file frontend-artifact.tgz -H 'Content-Type: application/octet-stream' http://iac-nexus-1:8081/repository/webAppArtifact/frontend-artifact-1.tgz"
                        nexusArtifactUploader(
                            [
                                nexusVersion: 'nexus3',
                                protocol: 'http',
                                nexusUrl: "${env.NEXUS_URL}",
                                repository: "${env.NEXUS_REPO}",
                                credentialsId: "${env.NEXUS_CREDENTIALS_ID}",
                                groupId: 'com.houdhem',
                                packaging: 'tgz',
                                version: '1.0.0',
                                artifacts: [
                                    [
                                        artifactId: '',
                                        classifier: '',
                                        file: "vite-project-0.0.0.tgz"
                                    ]
                                ]
                            ]
                        )

                    
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh 'whoami'
                    sh 'docker version'
                    sh 'docker build -t $DOCKER_REGISTRY:1 .'
                    sh 'ls'

                     withCredentials([usernamePassword(credentialsId: 'docker-cred', passwordVariable: 'password', usernameVariable: 'username')]) {
                        sh 'docker login -u "$username" -p "$password"'
                         
                        // Push Docker image to registry
                        sh 'docker push $DOCKER_REGISTRY:1'
                    }
                }
            }
        }

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
