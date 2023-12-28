pipeline {
    agent any

    environment {
        // Define environment variables here
        NEXUS_URL = 'iac-nexus-1:8081'
        NEXUS_REPO = 'front-repo'
        NEXUS_CREDENTIALS_ID = 'nexus-credentials'
        DOCKER_REGISTRY = 'houdhemassoudi/devops-front'
        DOCKER_CRED = credentials('docker-cred')
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
                    sh 'mv frontend-0.0.0.tgz frontend.tgz' 
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
                    sh "curl -v --user admin:1a5582c1-78d5-4d95-8500-fdc9a126034a --upload-file frontend.tgz -H 'Content-Type: application/octet-stream' http://iac-nexus-1:8081/repository/front-repo/frontend.tgz"
                        // nexusArtifactUploader(
                        //     [
                        //         nexusVersion: 'nexus3',
                        //         protocol: 'http',
                        //         nexusUrl: "${env.NEXUS_URL}",
                        //         repository: "${env.NEXUS_REPO}",
                        //         credentialsId: "${env.NEXUS_CREDENTIALS_ID}",
                        //         groupId: '',
                        //         packaging: 'tgz',
                        //         version: 'v1',
                        //         artifacts: [
                        //             [
                        //                 artifactId: '',
                        //                 classifier: '',
                        //                 file: "frontend.tgz"
                        //             ]
                        //         ]
                        //     ]
                        // )

                    
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
