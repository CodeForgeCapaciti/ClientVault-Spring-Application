# ClientVault – Client Management Application
## Project Overview
ClientVault is a Spring Boot–based Client Management Application designed to manage client information efficiently using a RESTful backend architecture. The application follows clean layered architecture principles and is built with Java and Spring technologies, making it suitable for enterprise-grade backend and microservice-oriented systems.


Microservice-ready backend design
# Technology Stack
## Backend

* Java: 25 
* Spring Boot: 4.0.2

* Spring Web

* Spring Data JPA 

* Hibernate 

## Database

* PostgreSQL

# Configuration

## application.properties
Database persistence using PostgreSQL
* spring.datasource.url=jdbc:postgresql://localhost:5432/clientvault_db
* spring.datasource.username=postgres
* spring.datasource.password=your_password
  
* spring.jpa.hibernate.ddl-auto=update
* spring.jpa.show-sql=true
* spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect

# Running the Application
* Run with Maven
mvn spring-boot:run

Access the Application
http://localhost:8080

# CRUD Endpoints
* All endpoints are prefixed with
* http://localhost:8080/clients

# Create Client
* POST /clients/add
* Adds a new line to the database
* http://localhost:8080/api/clients
* Example input: {
  "clientId": "C115",
  "fullName": "Teabo",
  "email": "Teaboabo@gmail.com",
  "phoneNumber": "0631177632",
  "address": "623 Joburg street"
  }

# Get All Clients
* GET /clients/all
* Retrieves a list of all clients in the database
* http://localhost:8080/api/clients

# Get Client by ID
* GET /clients/{id}
* Retrieves a single client using its database ID 

# Update Client
* PUT /clients/update/{id}
*  Updates an existing client's information

# Delete Client
* DELETE /clients/delete/{id}
* Deletes a client by its database ID
* http://localhost:8080/api/clients/{id}
