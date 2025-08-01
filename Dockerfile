# ----- STAGE 1: Build -----
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

# Copie du pom.xml pour utiliser le cache Docker
COPY pom.xml .
RUN mvn dependency:go-offline

# Copie du code source
COPY src ./src

# Build du projet sans lancer les tests
RUN mvn package -DskipTests


# ----- STAGE 2: Runtime -----
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copie du JAR compilé depuis l'étape de build
COPY --from=build /app/target/*.jar app.jar

# Expose le port (8761 pour un serveur Eureka typiquement)
EXPOSE 8761

# Commande de lancement
ENTRYPOINT ["java", "-jar", "app.jar"]
