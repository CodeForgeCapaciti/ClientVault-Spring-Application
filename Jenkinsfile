pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "durksie/clientvault-app"
        DOCKER_TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/CodeForgeCapaciti/ClientVault-Spring-Application.git'
            }
        }

        stage('Build & Test') {
            steps {
                echo "Building and testing Spring Boot application..."
                sh 'mvn clean test'
            }
        }

        stage('Package JAR') {
            steps {
                echo "Packaging JAR..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                echo "Building Docker image..."
                sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
            }
        }

        stage('Docker Compose Deploy') {
            steps {
                echo "Starting application with Docker Compose..."
                sh '''
                  docker-compose down
                  docker-compose up -d --build
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Jenkins Pipeline succeeded!"
        }
        failure {
            echo "❌ Jenkins Pipeline failed!"
        }
    }
}
