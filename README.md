# ClientVault – Client Management Application

## Overview
ClientVault is a CRUD-based Client Management backend application built using Java Spring Boot.  
It provides RESTful APIs to manage client records including creating, retrieving, updating, and deleting client information.

The project follows clean layered architecture principles and is designed to be microservice-ready, making it suitable for enterprise backend systems and DevOps deployment workflows.

---

## Architecture
- Layered architecture (Controller → Service → Repository → Database)
- RESTful API design
- Microservice-ready structure
- Containerized deployment support (Docker)
- CI/CD ready (Jenkins, Kubernetes, Terraform)

---

## Technology Stack

### Backend
- Java
- Spring Boot
- Spring Web
- Spring Data JPA
- Hibernate

### Database
- PostgreSQL

### DevOps & Infrastructure
- Docker
- Docker Compose
- Jenkins
- Kubernetes
- Terraform

---

## Configuration

Update your `application.properties` file:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/clientvault_db
spring.datasource.username=postgres
spring.datasource.password=your_password
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```
---
## Running the Application
### Prerequisites

- Java installed

- Maven installed

- PostgreSQL running

- Docker Installed 

#### Run locally with Maven
- mvn spring-boot:run

- Application runs at:

_http://localhost:8080_
  - API Endpoints

- Base URL:

_http://localhost:8080/clients_

### ➕ Create Client

- POST /add

- Adds a new client

- Example request body:

```{
  "clientId": "C115",
  "fullName": "John Doe",
  "email": "john@example.com",
  "phoneNumber": "0123456789",
  "address": "123 Main Street"
}
```

### Get All Clients

- GET /all

- Returns all clients

### Get Client by ID

- GET /{id}

- Returns a specific client

###  Update Client

- PUT /update/{id}

- Updates client details

### Delete Client

- DELETE /delete/{id}

- Removes a client

### Running with Docker

Build image:

_docker build -t clientvault ._

- Run container:

- docker run -p 8080:8080 clientvault

- Or use Docker Compose:

- docker-compose up

### Deployment

- The project includes:

- Kubernetes manifests (k8s/)

- Terraform scripts (terraform/)

- Jenkins pipeline (Jenkinsfile)

- Use these for automated infrastructure provisioning and deployment.

### Testing

- Run tests with:

- mvn test
  
- Contributors
 - Team members contributing to the ClientVault project.


 ## Future Improvements

- Add authentication (JWT / OAuth2)

- API documentation (Swagger/OpenAPI)

- Validation and error handling improvements

- Monitoring and logging

- Frontend integration