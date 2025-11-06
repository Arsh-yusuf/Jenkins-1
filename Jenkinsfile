pipeline {
    agent any

    environment {
        DEPLOY_USER = 'ubuntu'
        DEPLOY_HOST = 'your.server.ip'
        DEPLOY_PATH = '/tmp/deploy'
        APP_DIR = '/var/www/myapp'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/yourusername/Jenkins-1.git'
            }
        }

        stage('Build App') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }

        stage('Deploy to Server') {
            steps {
                sshagent (credentials: ['ssh-key-id']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $DEPLOY_USER@$DEPLOY_HOST 'rm -rf $DEPLOY_PATH && mkdir -p $DEPLOY_PATH'
                        scp -o StrictHostKeyChecking=no -r * $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH
                        ssh -o StrictHostKeyChecking=no $DEPLOY_USER@$DEPLOY_HOST 'bash $DEPLOY_PATH/deploy.sh'
                    """
                }
            }
        }
    }

    post {
        success {
            mail to: 'team@example.com',
                 subject: "✅ Jenkins Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build succeeded.\n\nCheck it here: ${env.BUILD_URL}"
        }
        failure {
            mail to: 'team@example.com',
                 subject: "❌ Jenkins Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build failed.\n\nCheck logs: ${env.BUILD_URL}"
        }
    }
}
