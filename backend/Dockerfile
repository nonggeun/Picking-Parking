# # FROM openjdk:21-jdk-slim

# # # 앱 디렉토리 생성
# # RUN mkdir -p /app

# # ENV APP_HOME=/app/
# # WORKDIR $APP_HOME

# # # .jar 파일을 /usr/app/ 디렉토리로 복사
# # COPY build/libs/*.jar app.jar
# # EXPOSE 8080

# # ENTRYPOINT ["java", "-jar", "/usr/app/PickingParking-0.0.1-SNAPSHOT.jar"]
FROM openjdk:21-jdk-slim


# JAR 파일 경로 변수 설정
ARG JAR_FILE=build/libs/PickingParking-0.0.1-SNAPSHOT.jar

# 작업 디렉토리 생성
WORKDIR /app
COPY .env /app/.env
COPY ./src/main/resources/certs /app/certs

# JAR 파일을 컨테이너에 복사
COPY ${JAR_FILE} /app.jar

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]

# FROM openjdk:21-jdk-slim

# # JAR 파일 경로 변수 설정
# ARG JAR_FILE=build/libs/PickingParking-0.0.1-SNAPSHOT.jar
# ARG CERT_FILE=backend/src/main/resources/certs/AmazonRootCA1.pem
# # 작업 디렉토리 생성
# WORKDIR /app

# # certs 디렉토리 생성
# RUN mkdir -p /app/certs

# # JAR 파일을 컨테이너에 복사
# COPY ${JAR_FILE} app.jar

# # 인증서 파일만 직접 복사
# COPY ${CERT_FILE} /app/certs/

# # 파일이 제대로 복사되었는지 확인 (디버깅용)
# RUN ls -la /app/certs

# # 애플리케이션 실행
# ENTRYPOINT ["java", "-jar", "/app/app.jar"]

# FROM openjdk:21-jdk-slim

# # JAR 파일 경로 변수 설정
# ARG JAR_FILE=build/libs/PickingParking-0.0.1-SNAPSHOT.jar
# ARG CERT_FILE=src/main/resources/certs/AmazonRootCA1.pem

# # 작업 디렉토리 생성
# WORKDIR /app

# # certs 디렉토리 생성
# RUN mkdir -p /app/certs

# # JAR 파일을 컨테이너에 복사
# COPY ${JAR_FILE} app.jar

# # 인증서 파일만 직접 복사
# COPY ${CERT_FILE} /app/certs/

# # 파일이 제대로 복사되었는지 확인 (디버깅용)
# RUN ls -la /app/certs

# # 애플리케이션 실행
# ENTRYPOINT ["java", "-jar", "/app/app.jar"]