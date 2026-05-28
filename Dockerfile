# 1. Base image (경량화된 데비안 사용)
FROM debian:stable-slim

# 2. 필수 패키지 설치 (curl, unzip)
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 3. Rojo 최신 버전 설치 (v7.4.1 기준)
# 참고: 아키텍처에 맞춰 리눅스용 바이너리를 다운로드합니다.
RUN curl -L https://github.com/rojo-rbx/rojo/releases/download/v7.4.1/rojo-7.4.1-linux.zip -o rojo.zip \
    && unzip rojo.zip -d /usr/local/bin \
    && rm rojo.zip \
    && chmod +x /usr/local/bin/rojo

# 4. 작업 디렉토리 설정
WORKDIR /app

# 5. Rojo 서버 포트 노출
EXPOSE 34872

# 6. 실행 명령 (모든 인터페이스에서 접속 가능하도록 0.0.0.0 설정)
CMD ["rojo", "serve", "--address", "0.0.0.0", "default.project.json"]
