FROM maven:3.9.9-amazoncorretto-21 AS build

WORKDIR /app

# Copy pom.xml and resolve dependencies early (cacheable layer)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source files and build
COPY src ./src
RUN mvn package -DskipTests

FROM amazoncorretto:21.0.6-al2-generic

LABEL org.opencontainers.image.title="Spring Boot Playground" \
      org.opencontainers.image.description="A sandbox environment project for experimenting with Spring Boot features and other integrations, Docker containerization, and GitHub Container Registry deployments." \
      org.opencontainers.image.url="https://github.com/ashfaq1211/spring-boot-playground" \
      org.opencontainers.image.source="https://github.com/ashfaq1211/spring-boot-playground.git" \
      org.opencontainers.image.vendor="Webstruct" \
      org.opencontainers.image.authors="Ashfaqul Islam"

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]