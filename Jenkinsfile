pipeline {
    agent { backend-app/dockerfile true }
    stages {
        stage('Test') {
            steps {
                sh 'python --version'
            }
        }
    }
}
