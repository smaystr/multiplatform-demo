# Налаштування проекту
APP_NAME := multiplatform-app
REPO_NAME := quay.io/smaystr
IMAGE_TAG := $(REPO_NAME)/$(APP_NAME):latest

# Git інформація
GIT_COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_TIME := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# Базові змінні для компіляції
GO := go
GOBUILD := $(GO) build
GOTEST := $(GO) test
LDFLAGS := -ldflags "-X main.BuildCommit=$(GIT_COMMIT) -X main.BuildTime=$(BUILD_TIME)"

# Директорії для збірки
OUTDIR := ./bin

# Створення вихідної директорії
$(shell mkdir -p $(OUTDIR))

# Стандартна ціль
.PHONY: all
all: clean build test

# Збірка для поточної платформи
.PHONY: build
build:
	@echo "Building for current platform..."
	$(GOBUILD) $(LDFLAGS) -o $(OUTDIR)/$(APP_NAME) ./cmd/app
	@echo "Built at $(OUTDIR)/$(APP_NAME)"

# Збірка для Linux (amd64)
.PHONY: linux
linux:
	@echo "Building for Linux (amd64)..."
	GOOS=linux GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(OUTDIR)/$(APP_NAME)-linux-amd64 ./cmd/app
	@echo "Built at $(OUTDIR)/$(APP_NAME)-linux-amd64"

# Збірка для Linux (arm64)
.PHONY: arm
arm:
	@echo "Building for Linux (arm64)..."
	GOOS=linux GOARCH=arm64 $(GOBUILD) $(LDFLAGS) -o $(OUTDIR)/$(APP_NAME)-linux-arm64 ./cmd/app
	@echo "Built at $(OUTDIR)/$(APP_NAME)-linux-arm64"

# Збірка для macOS (amd64)
.PHONY: macos
macos:
	@echo "Building for macOS (amd64)..."
	GOOS=darwin GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(OUTDIR)/$(APP_NAME)-darwin-amd64 ./cmd/app
	@echo "Built at $(OUTDIR)/$(APP_NAME)-darwin-amd64"

# Збірка для macOS (arm64)
.PHONY: macos-arm
macos-arm:
	@echo "Building for macOS (arm64)..."
	GOOS=darwin GOARCH=arm64 $(GOBUILD) $(LDFLAGS) -o $(OUTDIR)/$(APP_NAME)-darwin-arm64 ./cmd/app
	@echo "Built at $(OUTDIR)/$(APP_NAME)-darwin-arm64"

# Збірка для Windows (amd64)
.PHONY: windows
windows:
	@echo "Building for Windows (amd64)..."
	GOOS=windows GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(OUTDIR)/$(APP_NAME)-windows-amd64.exe ./cmd/app
	@echo "Built at $(OUTDIR)/$(APP_NAME)-windows-amd64.exe"

# Збірка для всіх платформ
.PHONY: all-platforms
all-platforms: linux arm macos macos-arm windows
	@echo "Built for all platforms"

# Запуск тестів
.PHONY: test
test:
	@echo "Running tests..."
	$(GOTEST) -v ./...

# Docker команди
.PHONY: docker-build
docker-build:
	@echo "Building Docker image for current platform..."
	docker build -t $(IMAGE_TAG) \
		--build-arg GIT_COMMIT=$(GIT_COMMIT) \
		--build-arg BUILD_TIME=$(BUILD_TIME) \
		.

# Збірка Docker для ARM64
.PHONY: docker-build-arm
docker-build-arm:
	@echo "Building Docker image for ARM64..."
	docker build -t $(IMAGE_TAG)-arm64 \
		--build-arg GIT_COMMIT=$(GIT_COMMIT) \
		--build-arg BUILD_TIME=$(BUILD_TIME) \
		--build-arg TARGETARCH=arm64 \
		.

# Збірка Docker для AMD64
.PHONY: docker-build-amd64
docker-build-amd64:
	@echo "Building Docker image for AMD64..."
	docker build -t $(IMAGE_TAG)-amd64 \
		--build-arg GIT_COMMIT=$(GIT_COMMIT) \
		--build-arg BUILD_TIME=$(BUILD_TIME) \
		--build-arg TARGETARCH=amd64 \
		.

# Збірка мультиплатформенного Docker образу
.PHONY: docker-buildx
docker-buildx:
	@echo "Building multi-platform Docker image..."
	docker buildx create --use --name multiplatform-builder || true
	docker buildx build --platform linux/amd64,linux/arm64 \
		--build-arg GIT_COMMIT=$(GIT_COMMIT) \
		--build-arg BUILD_TIME=$(BUILD_TIME) \
		-t $(IMAGE_TAG) --push .
	docker buildx rm multiplatform-builder

# Запуск Docker-контейнера
.PHONY: docker-run
docker-run:
	@echo "Running Docker container..."
	docker run --rm $(IMAGE_TAG)

# Очистка
.PHONY: clean
clean:
	@echo "Cleaning..."
	rm -rf $(OUTDIR)
	@echo "Removing Docker images..."
	-docker rmi $(IMAGE_TAG) 2>/dev/null || true
	-docker rmi $(IMAGE_TAG)-amd64 2>/dev/null || true
	-docker rmi $(IMAGE_TAG)-arm64 2>/dev/null || true
	-docker rmi $(APP_NAME):latest 2>/dev/null || true
	-docker rmi $(APP_NAME):v1.0.0 2>/dev/null || true
	-docker rmi $(REPO_NAME)/$(APP_NAME):v1.0.0 2>/dev/null || true
	-docker rmi ghcr.io/smaystr/$(APP_NAME):v1.0.0 2>/dev/null || true
	@echo "Clean completed."

# Для документації
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all                - Clean, build and test"
	@echo "  build              - Build for current platform"
	@echo "  linux              - Build for Linux (amd64)"
	@echo "  arm                - Build for Linux (arm64)"
	@echo "  macos              - Build for macOS (amd64)"
	@echo "  macos-arm          - Build for macOS (arm64)"
	@echo "  windows            - Build for Windows (amd64)"
	@echo "  all-platforms      - Build for all platforms"
	@echo "  test               - Run tests"
	@echo "  docker-build       - Build Docker image for current platform"
	@echo "  docker-build-arm   - Build Docker image for ARM64"
	@echo "  docker-build-amd64 - Build Docker image for AMD64"
	@echo "  docker-buildx      - Build multi-platform Docker image"
	@echo "  docker-run         - Run Docker container"
	@echo "  clean              - Clean build artifacts and Docker images"
	@echo "  help               - Show this help message" 