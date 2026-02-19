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

        stage('Docker Compose Up for Tests') {
            steps {
                echo "Starting Postgres for tests..."
                sh '''
                  docker-compose -f docker-compose.yml up -d postgres
                  # Wait until Postgres is healthy
                  until [ "$(docker inspect -f '{{.State.Health.Status}}' clientvault-db)" == "healthy" ]; do
                    echo "Waiting for Postgres..."
                    sleep 2
                  done
                '''
            }
        }

        stage('Build & Test') {
            steps {
                echo "Building and testing Spring Boot application..."
                sh '''
                  mvn clean test \
                    -Dspring.datasource.url=jdbc:postgresql://localhost:5433/client_vault \
                    -Dspring.datasource.username=postgres \
                    -Dspring.datasource.password="#Brayden1@"
                '''
            }
        }

        stage('Package JAR') {
            steps {
                echo "Packaging JAR..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build & Deploy') {
            steps {
                echo "Building Docker image and deploying app..."
                sh '''
                  docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
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
