# GitHub Actions 자동 빌드/배포 구현

## 워크플로우 파일 구조

### 파일 위치
```
.github/workflows/docker-build.yml
```

## 워크플로우 구성

### 1. 트리거 설정

```yaml
on:
  push:
    tags:
      - 'v*.*.*'
```

Git 태그 푸시 시 자동 실행 (`v0.1.0`, `v1.2.3`, `v2.0.0-beta.1` 등)

### 2. 워크플로우 단계

#### Step 1: 코드 체크아웃
```yaml
- name: Checkout
  uses: actions/checkout@v4
```

#### Step 2: Docker 메타데이터 추출
```yaml
- name: Docker meta
  id: meta
  uses: docker/metadata-action@v5
  with:
    images: kenshin579/toolbox
    tags: |
      type=semver,pattern={{version}}
      type=semver,pattern={{major}}.{{minor}}
      type=semver,pattern={{major}}
```

**태그 전략**:
- `v1.2.3` → `1.2.3`, `1.2`, `1`, `latest` (stable 버전)
- `v2.0.0-beta.1` → `2.0.0-beta.1` (프리릴리즈, latest 제외)

#### Step 3: QEMU 설정
```yaml
- name: Set up QEMU
  uses: docker/setup-qemu-action@v3
```

ARM64 아키텍처 빌드를 위한 에뮬레이터 설정

#### Step 4: Docker Buildx 설정
```yaml
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v3
```

멀티 아키텍처 빌드 환경 구성

#### Step 5: Docker Hub 로그인
```yaml
- name: Login to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}
```

**필요한 GitHub Secrets**:
- `DOCKER_USERNAME`: Docker Hub 사용자명
- `DOCKER_PASSWORD`: Docker Hub Access Token

#### Step 6: 빌드 & 푸시
```yaml
- name: Build and push
  uses: docker/build-push-action@v5
  with:
    context: .
    platforms: linux/amd64,linux/arm64
    push: true
    tags: ${{ steps.meta.outputs.tags }}
    labels: ${{ steps.meta.outputs.labels }}
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

**주요 설정**:
- `platforms`: amd64, arm64 멀티 아키텍처 지원
- `cache-from/cache-to`: GitHub Actions 캐시 활용으로 빌드 시간 단축
- `push: true`: 빌드 후 자동 푸시

## GitHub Secrets 설정 방법

### Docker Hub Access Token 생성

1. Docker Hub 로그인
2. Account Settings → Security → New Access Token
3. Access permissions: Read, Write, Delete
4. Token 복사 (한 번만 표시됨)

### GitHub Repository Secrets 설정

1. Repository → Settings → Secrets and variables → Actions
2. New repository secret 클릭
3. Secret 추가:
   - Name: `DOCKER_USERNAME`, Value: Docker Hub 사용자명
   - Name: `DOCKER_PASSWORD`, Value: 복사한 Access Token

## 실행 흐름

```
1. 개발자가 Git 태그 푸시
   $ git tag v0.2.0
   $ git push origin v0.2.0

2. GitHub Actions 자동 트리거

3. 워크플로우 실행
   - 코드 체크아웃
   - Docker 메타데이터 추출 (태그 전략 적용)
   - QEMU 설정
   - Docker Buildx 설정
   - Docker Hub 로그인
   - 멀티 아키텍처 이미지 빌드 (amd64, arm64)
   - Docker Hub에 푸시

4. 결과 확인
   - https://github.com/{username}/toolbox/actions
   - https://hub.docker.com/r/kenshin579/toolbox/tags
```

## 예상 결과

### Stable 버전 (v1.0.0)
```
kenshin579/toolbox:1.0.0
kenshin579/toolbox:1.0
kenshin579/toolbox:1
kenshin579/toolbox:latest
```

### 프리릴리즈 버전 (v2.0.0-beta.1)
```
kenshin579/toolbox:2.0.0-beta.1
```

## 성능 최적화

### 빌드 캐시
GitHub Actions 캐시를 사용하여 레이어 캐싱 활성화:
```yaml
cache-from: type=gha
cache-to: type=gha,mode=max
```

**효과**:
- 초기 빌드: ~3-5분
- 캐시 사용 후: ~1-2분 (변경 없을 경우 더 빠름)

## 보안

### Secret 보호
- GitHub Secrets는 워크플로우 로그에서 자동으로 마스킹됨
- `***` 형태로 표시되어 노출 방지

### Docker Hub Token 권한
- Personal Access Token (PAT) 사용
- 최소 권한 원칙: Read, Write 권한만 부여
- 정기적으로 토큰 갱신 권장 (6개월~1년)

## 문제 해결

### 빌드 실패 시
1. GitHub Actions 탭에서 워크플로우 실행 로그 확인
2. 각 Step의 에러 메시지 확인
3. 일반적인 원인:
   - Dockerfile 문법 오류
   - Docker Hub 자격증명 문제
   - 네트워크 타임아웃

### Docker Hub 로그인 실패
- Secret 이름 확인: `DOCKER_USERNAME`, `DOCKER_PASSWORD`
- Token 만료 여부 확인
- Token 권한 확인

### 멀티 아키텍처 빌드 실패
- QEMU 설정 단계가 정상 실행되었는지 확인
- Buildx 설정이 올바른지 확인
