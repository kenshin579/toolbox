# Kubernetes Toolbox

Kubernetes 클러스터 내에서 네트워크 및 애플리케이션 디버깅을 위한 올인원 도구 컨테이너입니다.

## 🎯 개요

Alpine Linux 기반의 경량 Docker 이미지로, Kubernetes 환경에서 문제를 진단하고 디버깅하는데 필요한 다양한 도구들을 포함하고 있습니다.

## 📦 포함된 도구

### 데이터베이스 클라이언트
- `mysql-client` - MySQL/MariaDB 연결 테스트
- `redis-cli` - Redis 연결 및 명령 실행

### 네트워크 진단 도구
- `ping` - 연결성 테스트
- `traceroute` - 네트워크 경로 추적
- `nslookup`, `dig`, `host` - DNS 조회
- `ip`, `ifconfig`, `route` - 네트워크 인터페이스 관리
- `tcpdump` - 패킷 캡처 및 분석
- `nmap` - 포트 스캔 및 네트워크 탐색

### HTTP 유틸리티
- `curl` - HTTP 요청 테스트
- `wget` - 파일 다운로드 및 HTTP 테스트

### 기타
- `bash` - 강력한 쉘 환경

## 🚀 빠른 시작

### Docker Hub에서 이미지 가져오기

```bash
docker pull kenshin579/toolbox:latest
```

### Kubernetes에서 디버깅 Pod 생성

```bash
# Pod 생성
kubectl run toolbox --image=kenshin579/toolbox:latest --command -- sleep infinity

# Pod에 접속
kubectl exec -it toolbox -- bash

# 사용 완료 후 삭제
kubectl delete pod toolbox
```

### 특정 네임스페이스에서 실행

```bash
kubectl run toolbox -n your-namespace --image=kenshin579/toolbox:latest --command -- sleep infinity
kubectl exec -it toolbox -n your-namespace -- bash
```

## 💡 사용 예제

### MySQL 연결 테스트

```bash
mysql -h mysql-service -u root -p
```

### Redis 연결 테스트

```bash
redis-cli -h redis-service -p 6379
redis-cli -h redis-service ping
```

### DNS 조회

```bash
nslookup my-service
dig my-service.default.svc.cluster.local
```

### HTTP 엔드포인트 테스트

```bash
curl http://my-service:8080/health
curl -v https://api.example.com
```

### 네트워크 연결 확인

```bash
ping google.com
traceroute my-service
```

### 포트 스캔

```bash
nmap -p 1-1000 my-service
```

### 패킷 캡처 (root 권한 필요)

```bash
tcpdump -i eth0 -n
tcpdump -i any port 3306
```

## 🛠️ 로컬 빌드

### 일반 빌드

```bash
make build
```

### 빌드 및 Docker Hub에 푸시

```bash
make build-push
```

### 멀티 아키텍처 빌드 (amd64, arm64)

```bash
make buildx
```

### 빌드 후 테스트

```bash
make test
```

## 🔧 버전 관리

`Makefile`에서 버전을 관리합니다:

```makefile
VERSION = v0.1.0
```

빌드 시 버전 태그와 `latest` 태그가 모두 생성됩니다.

## 📝 주의사항

- 이 이미지는 **root 권한**으로 실행됩니다 (`tcpdump`, `nmap` 등이 root 권한 필요)
- 프로덕션 환경에서 사용 시 보안 정책을 고려하세요
- 디버깅 완료 후에는 Pod를 삭제하는 것을 권장합니다

## 🏗️ 시스템 요구사항

- Docker 19.03 이상
- Kubernetes 1.19 이상 (권장)
- `docker buildx` (멀티 아키텍처 빌드 시)

## 📄 라이선스

이 프로젝트는 자유롭게 사용 가능합니다.

## 🤝 기여

이슈나 Pull Request는 언제든지 환영합니다!