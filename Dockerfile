# ===================================
# ESTÁGIO 1: BUILD
# ===================================
# Usando imagem OFICIAL do Maven com JDK 21
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

# Copiar arquivos do projeto
COPY pom.xml .
COPY src ./src

# Build do projeto (sem testes)
RUN mvn clean package -DskipTests

# ===================================
# ESTÁGIO 2: RUNTIME
# ===================================
# Usando imagem OFICIAL do Eclipse Temurin JDK 21
FROM eclipse-temurin:21-jre

# Expor porta 8080
EXPOSE 8080

# Definir diretório de trabalho
WORKDIR /app

# Copiar JAR do estágio anterior
COPY --from=build /app/target/*.jar app.jar

# Criar usuário não-root para segurança (NÃO RODA COMO ROOT)
RUN useradd -m -u 1001 appuser && chown -R appuser:appuser /app
USER appuser

# Variáveis de ambiente (serão sobrescritas no ACI)
ENV DATABASE_URL=jdbc:sqlserver://localhost:1433;database=motosdb
ENV DATABASE_USERNAME=sa
ENV DATABASE_PASSWORD=senha

# Comando para iniciar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
