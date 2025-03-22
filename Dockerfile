FROM maven:3.9.9-amazoncorretto-21 AS build

WORKDIR /app

# Copy pom.xml and resolve dependencies early (cacheable layer)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source files and build
COPY src ./src
RUN mvn package -DskipTests

FROM amazoncorretto:21.0.6-al2-generic

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]