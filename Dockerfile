# Використовуємо багатоетапний білд для мінімального розміру фінального образу
FROM quay.io/projectquay/golang:1.22 AS builder

# Встановлюємо робочу директорію
WORKDIR /app

# Копіюємо файли залежностей
COPY go.mod go.sum* ./
RUN go mod download

# Копіюємо вихідний код
COPY . .

# Отримуємо інформацію про Git-коміт і час збірки
ARG GIT_COMMIT=unknown
ARG BUILD_TIME=unknown

# Збираємо додаток з правильними змінними версії
ARG TARGETOS=linux
ARG TARGETARCH=amd64
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -ldflags="-X main.BuildCommit=${GIT_COMMIT} -X main.BuildTime=${BUILD_TIME}" \
    -o /app/out/multiplatform-app ./cmd/app

# Фінальний етап створення легкого образу
FROM scratch

# Копіюємо виконуваний файл з етапу builder
COPY --from=builder /app/out/multiplatform-app /multiplatform-app

# Запускаємо додаток при старті контейнера
ENTRYPOINT ["/multiplatform-app"] 