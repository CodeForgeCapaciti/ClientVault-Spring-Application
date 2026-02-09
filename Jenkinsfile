// Jenkinsfile - CI/CD Pipeline for ClientVault
pipeline {
    agent any



    environment {
        DOCKER_REGISTRY = 'https://index.docker.io/v1/'
        IMAGE_NAME = 'durksie/clientvault-app'  // Change to YOUR Docker Hub username
        VERSION = "${env.BUILD_NUMBER}"
        DOCKER_APP_NAME = 'clientvault-app'
        DOCKER_DB_NAME = 'clientvault-db'
    }

    stages {
        // STAGE 1: Code Checkout
        stage('Checkout Code') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/CodeForgeCapaciti/ClientVault-Spring-Application',  // CHANGE THIS
                        credentialsId: 'github-credentials'
                    ]]
                ])
                sh 'echo "Repository: ${GIT_URL}"'
                sh 'echo "Branch: ${GIT_BRANCH}"'
                sh 'echo "Commit: ${GIT_COMMIT}"'
            }
        }

        // STAGE 2: Build Application
        stage('Build with Maven') {
            steps {
                sh '''
                    echo "Building Spring Boot application..."
                    mvn clean compile
                    echo "Build completed successfully!"
                '''
            }
            post {
                success {
                    echo '✅ Build stage completed'
                }
                failure {
                    echo '❌ Build stage failed'
                }
            }
        }

        // STAGE 3: Run Tests
        stage('Run Tests') {
            steps {
                sh '''
                    echo "Running unit tests..."
                    mvn test
                    echo "Tests completed!"
                '''
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                    archiveArtifacts 'target/*.jar'
                }
            }
        }

        // STAGE 4: Package Application
        stage('Package JAR') {
            steps {
                sh '''
                    echo "Packaging application..."
                    mvn package -DskipTests
                    echo "JAR file created: target/clientVault-0.0.1-SNAPSHOT.jar"
                '''
            }
        }

        // STAGE 5: Build Docker Images
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        echo "Building Docker image..."
                        docker build -t ${IMAGE_NAME}:${VERSION} .
                        docker tag ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:latest
                        echo "Docker images created:"
                        docker images | grep ${IMAGE_NAME}
                    """
                }
            }
        }

        // STAGE 6: Run Integration Tests with Docker Compose
        stage('Integration Tests') {
            steps {
                sh '''
                    echo "Starting services for integration tests..."
                    docker-compose up -d
                    sleep 30  # Wait for services to start

                    echo "Running integration tests..."
                    mvn verify -DskipUnitTests

                    echo "Stopping services..."
                    docker-compose down
                '''
            }
        }

        // STAGE 7: Push to Docker Hub
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh """
                            echo "Logging into Docker Hub..."
                            echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin

                            echo "Pushing images to Docker Hub..."
                            docker push ${IMAGE_NAME}:${VERSION}
                            docker push ${IMAGE_NAME}:latest

                            echo "✅ Images pushed successfully!"
                            echo "Image: ${IMAGE_NAME}:${VERSION}"
                            echo "Image: ${IMAGE_NAME}:latest"
                        """
                    }
                }
            }
        }

        // STAGE 8: Deploy to Staging
        stage('Deploy to Staging Environment') {
            steps {
                sh '''
                    echo "Deploying to staging..."

                    # Stop and remove existing containers
                    docker stop ${DOCKER_APP_NAME} ${DOCKER_DB_NAME} 2>/dev/null || true
                    docker rm ${DOCKER_APP_NAME} ${DOCKER_DB_NAME} 2>/dev/null || true

                    # Start PostgreSQL
                    docker run -d \
                      --name ${DOCKER_DB_NAME} \
                      -e POSTGRES_DB=clientvault_db \
                      -e POSTGRES_USER=postgres \
                      -e POSTGRES_PASSWORD=postgres123 \
                      -p 5433:5432 \
                      --network bridge \
                      postgres:15-alpine

                    sleep 10  # Wait for database

                    # Start Application
                    docker run -d \
                      --name ${DOCKER_APP_NAME} \
                      -p 8081:8080 \
                      -e SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5433/clientvault_db \
                      -e SPRING_DATASOURCE_USERNAME=postgres \
                      -e SPRING_DATASOURCE_PASSWORD=postgres123 \
                      ${IMAGE_NAME}:latest

                    echo "✅ Deployment completed!"
                    echo "Application: http://localhost:8081"
                    echo "Database: localhost:5433"
                '''
            }
        }

        // STAGE 9: Health Check
        stage('Health Check') {
            steps {
                sh '''
                    echo "Performing health checks..."
                    sleep 10

                    # Check application health
                    if curl -s http://localhost:8081/actuator/health | grep -q "UP"; then
                        echo "✅ Application is healthy"
                    else
                        echo "❌ Application health check failed"
                        exit 1
                    fi

                    # Check database connection
                    if docker exec ${DOCKER_DB_NAME} pg_isready -U postgres; then
                        echo "✅ Database is healthy"
                    else
                        echo "❌ Database health check failed"
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline completed with status: ${currentBuild.result}"
            cleanWs()  // Clean workspace
        }
        success {
            echo '🎉 Pipeline SUCCESS!'
            emailext (
                subject: "SUCCESS: ClientVault Pipeline - Build #${env.BUILD_NUMBER}",
                body: """
                Build #${env.BUILD_NUMBER} of ClientVault completed SUCCESSFULLY!

                Details:
                - Job: ${env.JOB_NAME}
                - Build: #${env.BUILD_NUMBER}
                - Status: ${currentBuild.result}
                - Duration: ${currentBuild.durationString}
                - Docker Image: ${IMAGE_NAME}:${VERSION}

                View console output: ${env.BUILD_URL}

                Application deployed to: http://localhost:8081
                """,
                to: 'durksie1@gmail.com',  // CHANGE THIS
                attachLog: true
            )
        }
        failure {
            echo '❌ Pipeline FAILED!'
            emailext (
                subject: "FAILURE: ClientVault Pipeline - Build #${env.BUILD_NUMBER}",
                body: """
                Build #${env.BUILD_NUMBER} of ClientVault FAILED!

                Details:
                - Job: ${env.JOB_NAME}
                - Build: #${env.BUILD_NUMBER}
                - Status: ${currentBuild.result}

                Please check the console output: ${env.BUILD_URL}
                """,
                to: 'durksie1@gmail.com',  // CHANGE THIS
                attachLog: true
            )
        }
        cleanup {
            // Clean up Docker resources
            sh '''
                echo "Cleaning up Docker resources..."
                docker stop ${DOCKER_APP_NAME} ${DOCKER_DB_NAME} 2>/dev/null || true
                docker rm ${DOCKER_APP_NAME} ${DOCKER_DB_NAME} 2>/dev/null || true
                docker system prune -f
            '''
        }
    }
}