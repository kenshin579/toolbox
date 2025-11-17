FROM alpine:3.19

# 메타데이터
LABEL description="Kubernetes debugging toolbox with network diagnostic tools"

# 필수 도구 설치
RUN apk add --no-cache \
    mysql-client \
    redis \
    iputils \
    traceroute \
    bind-tools \
    iproute2 \
    curl \
    wget \
    tcpdump \
    nmap \
    busybox-extras \
    bash \
    && rm -rf /var/cache/apk/*

# Root 사용자로 실행 (기본값, USER 지시문 없음)
# tcpdump, nmap 등은 root 권한 필요

# 작업 디렉토리
WORKDIR /root

# 기본 쉘을 bash로 설정
ENV SHELL=/bin/bash

# 무한 대기 (Kubernetes에서 sleep infinity 명령 사용)
CMD ["/bin/bash"]
