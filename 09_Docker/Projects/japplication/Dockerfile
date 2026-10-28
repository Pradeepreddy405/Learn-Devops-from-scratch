# 1️⃣ Base image (Java)
FROM openjdk:17-jdk-slim

# 2️⃣ Create app directory inside container
WORKDIR /app

# 3️⃣ Copy JAR file into container
COPY target/user-app.jar app.jar

# 4️⃣ Expose application port
EXPOSE 8080

# 5️⃣ Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
