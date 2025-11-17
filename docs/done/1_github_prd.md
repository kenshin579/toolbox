# GitHub Actions 자동 빌드/배포 워크플로우 PRD

## 📋 목표

Git 태그 생성 시 자동으로 Docker 이미지를 빌드하고 Docker Hub에 푸시하는 CI/CD 파이프라인 구축

## 🎯 배경

현재 수동으로 `make buildx` 명령을 실행하여 멀티 아키텍처 이미지를 빌드하고 푸시하고 있습니다. 이를 자동화하여:
- 배포 프로세스의 일관성 확보
- 인적 오류 감소
- 버전 관리 자동화
- 개발 생산성 향상

## ✅ 요구사항

### 기능 요구사항

1. **트리거 조건**
   - Git 태그 푸시 시 자동 실행 (`v*.*.*` 패턴)
   - 예: `v0.1.0`, `v1.2.3`, `v2.0.0-beta.1`

2. **빌드 요구사항**
   - 멀티 아키텍처 지원: `linux/amd64`, `linux/arm64`
   - Docker Buildx 사용
   - 빌드 캐시 활용으로 빌드 시간 최적화

3. **태그 관리**
   - Git 태그를 Docker 이미지 태그로 사용
   - `latest` 태그 자동 업데이트 (stable 버전만)
   - 프리릴리즈 버전은 `latest` 태그 제외

4. **푸시 대상**
   - Docker Hub: `kenshin579/toolbox`
   - 인증: GitHub Secrets 사용

### 비기능 요구사항

1. **성능**
   - 빌드 시간: 5분 이내 목표
   - Layer 캐싱으로 재빌드 시간 단축

2. **보안**
   - Docker Hub 자격증명은 GitHub Secrets에 저장
   - 빌드 로그에 민감정보 노출 금지

3. **안정성**
   - 빌드 실패 시 알림
   - 재시도 로직 (네트워크 오류 대응)

## 🔧 기술 스펙

### 워크플로우 파일 위치
```
.github/workflows/docker-build.yml
```

### 필요한 GitHub Secrets

| Secret Name | 설명 | 예시 |
|-------------|------|------|
| `DOCKER_USERNAME` | Docker Hub 사용자명 | `kenshin579` |
| `DOCKER_PASSWORD` | Docker Hub Access Token | `dckr_pat_xxx...` |

### 사용 기술 스택
- **GitHub Actions**: CI/CD 플랫폼
- **Docker Buildx**: 멀티 아키텍처 빌드
- **Docker Hub**: 이미지 레지스트리

## 📝 관련 문서

- **구현 가이드**: `1_github_implementation.md` - 워크플로우 구현 세부사항
- **작업 체크리스트**: `1_github_todo.md` - 단계별 TODO 목록

## 📚 참고 자료

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Buildx Documentation](https://docs.docker.com/buildx/working-with-buildx/)
- [Docker Hub Access Tokens](https://docs.docker.com/docker-hub/access-tokens/)
- [GitHub Actions: docker/build-push-action](https://github.com/docker/build-push-action)
