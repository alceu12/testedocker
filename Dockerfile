    #
    # Build stage
    #
    FROM maven:3.8.3-openjdk-17 AS build
    COPY . .
    # Build do Maven SEM testes unitarios
    # RUN mvn clean install -DSkipTests=true
    RUN mvn clean install -DskipTests=true

    #
    # Package stage
    #
    FROM eclipse-temurin:17-jdk
    COPY --from=build /target/CentralDasImagens-0.0.1-SNAPSHOT.jar CentralDasImagens.jar
    # ENV PORT=8080
    EXPOSE 8080
    ENTRYPOINT ["java","-jar","CentralDasImagens.jar"]