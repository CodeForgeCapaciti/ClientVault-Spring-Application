pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "durksie/clientvault-app"
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/CodeForgeCapaciti/ClientVault-Spring-Application.git'
            }
        }

        stage('Build JAR') {
            steps {
                echo "Building Spring Boot application..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Run Unit Tests') {
            steps {
                echo "Running unit tests..."
                sh 'mvn test'
            }
        }

        stage('Docker Build') {
            steps {
                echo "Building Docker image..."
                sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
            }
        }

        stage('Docker Compose Up') {
            steps {
                echo "Deploying containers with Docker Compose..."
                sh '''
                  # Ensure Postgres container is healthy before starting app
                  docker-compose up -d --build
                  sleep 10
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline succeeded!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
