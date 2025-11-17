# Toolbox Docker 이미지 빌드/푸시 자동화

# 변수 정의
DOCKER_REGISTRY = kenshin579
IMAGE_NAME = toolbox
VERSION = v0.1.0

.PHONY: build push build-push test buildx clean

# 이미지 빌드
build:
	@echo "Building $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION)..."
	docker build -t $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION) .
	docker tag $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION) \
		$(DOCKER_REGISTRY)/$(IMAGE_NAME):latest
	@echo "Build complete!"

# 이미지 푸시
push:
	@echo "Pushing $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION)..."
	docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION)
	docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME):latest
	@echo "Push complete!"

# 빌드 & 푸시 한번에
build-push: build push

# 빌드 후 기본 테스트
test: build
	@echo "Testing built image..."
	docker run --rm $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION) id
	docker run --rm $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION) mysql --version
	docker run --rm $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION) redis-cli --version
	docker run --rm $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION) ping -c 1 google.com
	docker run --rm $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION) curl --version
	@echo "All tests passed!"

# 멀티 아키텍처 빌드 (amd64, arm64)
buildx:
	@echo "Building multi-architecture image..."
	docker buildx create --use --name toolbox-builder || true
	docker buildx build --platform linux/amd64,linux/arm64 \
		-t $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION) \
		-t $(DOCKER_REGISTRY)/$(IMAGE_NAME):latest \
		--push .
	@echo "Multi-arch build complete!"

# 로컬 이미지 삭제
clean:
	@echo "Removing local images..."
	docker rmi $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION) || true
	docker rmi $(DOCKER_REGISTRY)/$(IMAGE_NAME):latest || true
	@echo "Cleanup complete!"
