# Multiplatform Demo

Проект демонструє можливості мультиплатформенної збірки з використанням Makefile та Docker для підтримки різних операційних систем та архітектур.

## Функціональність

Додаток відображає інформацію про систему, на якій він запущений, включаючи:
- Операційну систему
- Архітектуру процесора
- Версію Go
- Інформацію про середовище

## Вимоги

- Go 1.20+
- Docker 20.10.0+ (для контейнеризації)
- Docker Buildx (для мультиплатформної збірки)
- Make

## Збірка

### Для різних платформ

```sh
# Для Linux (amd64)
make linux

# Для Linux (arm64)
make arm

# Для macOS (amd64)
make macos

# Для macOS (arm64)
make macos-arm

# Для Windows (amd64)
make windows

# Для всіх платформ одночасно
make all-platforms
```

### Docker-збірка

```sh
# Для поточної платформи
make docker-build

# Для ARM64
make docker-build-arm

# Для AMD64
make docker-build-amd64

# Мультиплатформна збірка (потрібен docker buildx)
make docker-buildx
```

## Запуск

### Локально

```sh
# Використовуючи збірку для поточної платформи
./bin/multiplatform-app
```

### У Docker

```sh
# Запуск Docker-контейнера
make docker-run
```

### Використовуючи Docker Compose

```sh
# Для AMD64
docker-compose up

# Для ARM64
TARGETARCH=arm64 docker-compose up
```

## Очистка

```sh
# Видалення бінарних файлів і Docker-образів
make clean
```

## Структура проекту

```
.
├── cmd/
│   └── app/              # Вихідний код додатку
│       ├── main.go       # Головний файл
│       └── version.go    # Інформація про версію
├── bin/                  # Директорія для бінарних збірок
├── Dockerfile            # Для контейнеризації
├── docker-compose.yml    # Для запуску в Docker
├── Makefile              # Автоматизація збірки
└── README.md             # Документація
```

## Ліцензія

MIT 