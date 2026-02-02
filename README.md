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

* PostgreSQ

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
