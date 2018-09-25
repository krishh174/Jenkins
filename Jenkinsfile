pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build("krishh11234/php-app")
                    app.inside {
                        sh 'echo $(curl localhost:8080)'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_creds') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('Deploy PHP Dockerized Application') {
            when {
                branch 'master'
            }
            steps {
                script {
                    try {
                            sh "docker stop php-app"
                            sh "docker rm php-app"
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "docker run --restart always --name php-app -p 8081:8081 -d krishh11234/php-app:${env.BUILD_NUMBER}"
                       }
                   }
    }
        stage('Deploy to Production environment') {
            when {
                branch 'master'
            }
            steps {
                input 'Deploy to Production?'
                milestone(1)
                def dockerStop = 'docker stop php-app'
                def dockerRemove = 'docker rm php-app'
                def dockerRun = "docker run --restart always --name php-app -p 8081:8081 -d krishh11234/php-app:${env.BUILD_NUMBER}"
                sshagent(['prod-creds']) {
                    try {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@$prod_ip ${dockerStop}"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@$prod_ip ${dockerRemove}"
                    } catch (err) {
                        echo: 'caught error: $err'
                    }
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@$prod_ip ${dockerRun}"
                }
            }
        }
  }
}
