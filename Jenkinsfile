pipeline {
    agent any
    
    environment {
        REPO_WEB = 'arunrascall/ruby-web'
        REPO_POSTGRES = 'arunrascall/ruby-postgres'
    }
    
    stages {
        stage('Git Checkout'){
            steps{
            git branch: 'main', url: 'https://github.com/ARUNKUMAAR-R/Budget-ROR.git'
            }
        }
        
        
        stage('Building Docker Images'){
            steps{
            sh 'sudo docker compose up -d'
            sh 'sudo docker compose down --volumes --remove-orphans'
            sh 'sudo docker tag budget-application-web:latest "${REPO_WEB}:${BUILD_NUMBER}"'
            sh 'sudo docker tag "${REPO_WEB}:${BUILD_NUMBER}" "${REPO_WEB}:latest"'
            sh 'sudo docker tag postgres:14.2-alpine "${REPO_POSTGRES}:${BUILD_NUMBER}"'
            sh 'sudo docker tag "${REPO_POSTGRES}:${BUILD_NUMBER}" "${REPO_POSTGRES}:latest"'
            }
        }
        
        stage('Scanning Docker Images'){
            steps{
            sh 'sudo trivy image --format json --severity HIGH,CRITICAL "${REPO_WEB}:${BUILD_NUMBER}"  > ruby-web_scan-${BUILD_NUMBER}.json'
            sh 'sudo trivy image --format json --severity HIGH,CRITICAL  "${REPO_POSTGRES}:${BUILD_NUMBER}" > ruby-postgres_scan-${BUILD_NUMBER}.json'

            }
        }
        
        stage('Pushing images to DockerHub'){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'Docker-Cred', url: 'https://index.docker.io/v1/') {
                        sh 'sudo docker push ${REPO_WEB}:${BUILD_NUMBER} && sudo docker push "${REPO_WEB}:latest"'
                        sh 'sudo docker push "${REPO_POSTGRES}:${BUILD_NUMBER}" && sudo docker push "${REPO_POSTGRES}:latest"'
                    }
                }
            }
        }
        
    }
        
        
}
