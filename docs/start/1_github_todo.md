# GitHub Actions 자동 빌드/배포 TODO

## Phase 1: 사전 준비

### 1.1 Docker Hub Access Token 생성
- [ ] Docker Hub 로그인
- [ ] Account Settings → Security 이동
- [ ] New Access Token 생성
  - Token description: `github-actions-toolbox`
  - Access permissions: Read, Write, Delete
- [ ] 생성된 Token 복사 및 안전한 곳에 저장

### 1.2 GitHub Secrets 설정
- [ ] GitHub Repository 접속
- [ ] Settings → Secrets and variables → Actions 이동
- [ ] `DOCKER_USERNAME` Secret 추가
  - Name: `DOCKER_USERNAME`
  - Value: Docker Hub 사용자명 (`kenshin579`)
- [ ] `DOCKER_PASSWORD` Secret 추가
  - Name: `DOCKER_PASSWORD`
  - Value: 복사한 Docker Hub Access Token

## Phase 2: 워크플로우 구현

### 2.1 디렉토리 생성
- [x] `.github/workflows/` 디렉토리 생성 (없을 경우)
  ```bash
  mkdir -p .github/workflows
  ```

### 2.2 워크플로우 파일 작성
- [x] `.github/workflows/docker-build.yml` 파일 생성
- [x] 워크플로우 기본 구조 작성
  - [x] 트리거 설정 (`on: push: tags`)
  - [x] Job 정의 (`build-and-push`)
  - [x] Runner 설정 (`runs-on: ubuntu-latest`)

### 2.3 워크플로우 Step 구현
- [x] Step 1: 코드 체크아웃 (`actions/checkout@v4`)
- [x] Step 2: Docker 메타데이터 추출 (`docker/metadata-action@v5`)
  - [x] 이미지 이름 설정 (`kenshin579/toolbox`)
  - [x] 태그 전략 설정 (semver)
- [x] Step 3: QEMU 설정 (`docker/setup-qemu-action@v3`)
- [x] Step 4: Docker Buildx 설정 (`docker/setup-buildx-action@v3`)
- [x] Step 5: Docker Hub 로그인 (`docker/login-action@v3`)
  - [x] Secrets 연결 (`DOCKER_USERNAME`, `DOCKER_PASSWORD`)
- [x] Step 6: 빌드 & 푸시 (`docker/build-push-action@v5`)
  - [x] 멀티 플랫폼 설정 (`linux/amd64,linux/arm64`)
  - [x] 캐시 설정 (`type=gha`)
  - [x] Push 활성화

### 2.4 파일 커밋
- [ ] Git add 및 commit
  ```bash
  git add .github/workflows/docker-build.yml docs/start/1_github_todo.md
  git commit -m "Add GitHub Actions workflow for Docker build and push"
  ```
- [ ] feature 브랜치에 push
  ```bash
  git push origin feature/github-actions-docker-build
  ```

## Phase 3: 테스트

### 3.1 테스트 태그 생성 및 푸시
- [ ] 테스트 태그 생성
  ```bash
  git tag v0.1.1-test
  ```
- [ ] 태그 푸시
  ```bash
  git push origin v0.1.1-test
  ```

### 3.2 워크플로우 실행 확인
- [ ] GitHub Repository → Actions 탭 이동
- [ ] 워크플로우 실행 상태 확인
- [ ] 각 Step별 로그 확인
- [ ] 빌드 성공 여부 확인

### 3.3 Docker Hub 이미지 확인
- [ ] Docker Hub 접속 (https://hub.docker.com/r/kenshin579/toolbox/tags)
- [ ] `0.1.1-test` 태그가 생성되었는지 확인
- [ ] 멀티 아키텍처 지원 확인 (amd64, arm64)

### 3.4 로컬 이미지 테스트
- [ ] 이미지 Pull
  ```bash
  docker pull kenshin579/toolbox:0.1.1-test
  ```
- [ ] 이미지 실행 테스트
  ```bash
  docker run --rm kenshin579/toolbox:0.1.1-test id
  ```
- [ ] 멀티 아키텍처 매니페스트 확인
  ```bash
  docker manifest inspect kenshin579/toolbox:0.1.1-test
  ```

### 3.5 테스트 태그 정리
- [ ] 로컬 태그 삭제
  ```bash
  git tag -d v0.1.1-test
  ```
- [ ] 원격 태그 삭제
  ```bash
  git push origin :refs/tags/v0.1.1-test
  ```
- [ ] 로컬 이미지 정리
  ```bash
  docker rmi kenshin579/toolbox:0.1.1-test
  ```

## Phase 4: 프로덕션 배포

### 4.1 Stable 버전 테스트
- [ ] Stable 버전 태그 생성 (`v0.2.0`)
  ```bash
  git tag v0.2.0
  git push origin v0.2.0
  ```
- [ ] 워크플로우 실행 확인
- [ ] Docker Hub에서 태그 확인
  - [ ] `0.2.0` 태그 존재
  - [ ] `0.2` 태그 존재
  - [ ] `0` 태그 존재
  - [ ] `latest` 태그 업데이트 확인

### 4.2 프리릴리즈 버전 테스트 (선택)
- [ ] 베타 버전 태그 생성 (`v0.3.0-beta.1`)
  ```bash
  git tag v0.3.0-beta.1
  git push origin v0.3.0-beta.1
  ```
- [ ] Docker Hub에서 태그 확인
  - [ ] `0.3.0-beta.1` 태그만 생성
  - [ ] `latest` 태그는 업데이트되지 않음 확인

### 4.3 문서 업데이트
- [ ] README.md에 자동 배포 프로세스 설명 추가
  - [ ] 태그 생성 방법
  - [ ] 자동 빌드 프로세스 설명
  - [ ] Docker Hub 이미지 확인 방법
- [ ] 변경사항 커밋 및 푸시

## Phase 5: 모니터링 및 유지보수

### 5.1 빌드 성공률 모니터링
- [ ] GitHub Actions 탭에서 주기적으로 워크플로우 실행 상태 확인
- [ ] 실패 시 로그 분석 및 문제 해결

### 5.2 Docker Hub Token 관리
- [ ] Token 만료일 기록
- [ ] 6개월~1년 후 Token 갱신 계획

## 체크리스트 요약

**필수 사전 작업** (Phase 1):
- [ ] Docker Hub Access Token 생성 완료
- [ ] GitHub Secrets 설정 완료 (`DOCKER_USERNAME`, `DOCKER_PASSWORD`)

**핵심 구현** (Phase 2):
- [x] `.github/workflows/docker-build.yml` 파일 작성 완료
- [ ] 워크플로우 커밋 및 푸시 완료

**검증** (Phase 3):
- [ ] 테스트 태그로 워크플로우 정상 작동 확인
- [ ] Docker Hub에 이미지 정상 푸시 확인
- [ ] 멀티 아키텍처 빌드 확인

**프로덕션** (Phase 4):
- [ ] Stable 버전 배포 확인
- [ ] 문서 업데이트 완료
