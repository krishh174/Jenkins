pipeline {
    agent any
    stages {
        /*stage('SCM Checkout') {
            steps {
                git credentialsId: 'github_api_key', url: 'https://github.com/krishh174/Jenkins'
            }
        }*/
        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build("krishh11234/php-app")
                    app.inside {
                        sh 'echo $(curl 18.191.162.96:80)'
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
                        sh "docker run --restart always --name php-app -p 80:80 -d krishh11234/php-app:${env.BUILD_NUMBER}"
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
                //def dockerStop = 'docker stop php-app'
                //def dockerRemove = 'docker rm php-app'
                //def dockerRun = "docker run --restart always --name php-app -p 80:80 -d krishh11234/php-app:${env.BUILD_NUMBER}"
                sshagent(['prod-creds']) {
                    script {
                        try {
                        //sh "ssh -o StrictHostKeyChecking=no ec2-user@$prod_ip ${dockerStop}"
                        //sh "ssh -o StrictHostKeyChecking=no ec2-user@$prod_ip ${dockerRemove}"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@$prod_ip \"docker stop php-app\""
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@$prod_ip \"docker rm php-app\""
                    } catch (err) {
                        echo: 'caught error: $err'
                    }
                    //sh "ssh -o StrictHostKeyChecking=no ec2-user@$prod_ip ${dockerRun}"
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@$prod_ip \"docker run --restart always --name php-app -p 80:80 -d krishh11234/php-app:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }
        stage('Email regarding the Build') {
            when {
                branch 'master'
            }
            steps {
               //emailext body: 'Your Build was Successful', recipientProviders: [upstreamDevelopers()], subject: 'Jenkins Pipeline Project', to: 'saim.pro9@gmail.com' 
               //emailext body: '''$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:

                //Check console output at $BUILD_URL to view the results.''', recipientProviders: [developers()], subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'saim.pro9@gmail.com'
                emailext body: '''$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:

                Check console output at $BUILD_URL to view the results.''', compressLog: true, recipientProviders: [developers()], subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'saim.pro9@gmail.com'
            }
        }
  }
}
