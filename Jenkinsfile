pipeline {
    agent any

    environment {
        DEPLOY_USER = 'ubuntu'
        DEPLOY_HOST = '3.108.215.61'
        DEPLOY_PATH = '/tmp/deploy'
        APP_DIR = '/var/www/myapp'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-credentials',
                    url: 'https://github.com/Arsh-yusuf/Jenkins-1.git'
            }
        }

        stage('Build App') {
            steps {
                bat 'npm install'
                bat 'npm run build'
            }
        }

                stage('Deploy to Server') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key-id', 
                                                  keyFileVariable: 'SSH_KEY', 
                                                  usernameVariable: 'SSH_USER')]) {
                    bat """
                        set PATH=C:\\Windows\\System32\\OpenSSH;%PATH%
                        echo Deploying using key: %SSH_KEY%
                        ssh -i "%SSH_KEY%" -o StrictHostKeyChecking=no %SSH_USER%@%DEPLOY_HOST% "rm -rf %DEPLOY_PATH% && mkdir -p %DEPLOY_PATH%"
                        scp -i "%SSH_KEY%" -o StrictHostKeyChecking=no -r * %SSH_USER%@%DEPLOY_HOST%:%DEPLOY_PATH%
                        ssh -i "%SSH_KEY%" -o StrictHostKeyChecking=no %SSH_USER%@%DEPLOY_HOST% "bash %DEPLOY_PATH%/deploy.sh"
                    """
                }
            }
        }

    }

    post {
        success {
            mail to: 'yusufracer594@gmail.com',
                 subject: "✅ Jenkins Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build succeeded.\n\nCheck it here: ${env.BUILD_URL}"
        }
        failure {
            mail to: 'yusufracer594@gmail.com',
                 subject: "❌ Jenkins Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build failed.\n\nCheck logs: ${env.BUILD_URL}"
        }
    }
}
