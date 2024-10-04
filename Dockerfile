# Etapa de build, usa uma imagem base do Maven com JDK 17 para compilar a aplicação
FROM maven:3.8.4-openjdk-17 AS build

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o arquivo pom.xml para o diretório de trabalho no contêiner
COPY pom.xml .

# Copia todo o diretório de código-fonte da aplicação (src) para o diretório de trabalho no contêiner
COPY src ./src

# Executa o comando Maven para limpar e empacotar a aplicação, ignorando os testes
RUN mvn clean package -DskipTests

# Etapa de execução, usa uma imagem menor com OpenJDK 17 baseado no Alpine, que é mais leve
FROM openjdk:17-jdk-alpine

# Define o diretório de trabalho para a etapa de execução
WORKDIR /app

# Copia o arquivo .jar gerado na etapa anterior (build) para o diretório de trabalho do contêiner
COPY --from=build /app/target/*.jar app.jar

# Expõe a porta 8080, que é a porta padrão da aplicação Spring Boot
EXPOSE 8080

# Define o comando de entrada para rodar a aplicação Java
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
