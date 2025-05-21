# Multiplatform Demo

Проект демонструє можливості мультиплатформенної збірки з використанням Makefile та Docker для підтримки різних операційних систем та архітектур.

## Проблема, яку вирішує проект

Цей проект створено як рішення проблем із тимчасовими директоріями, що виникали в попередньому проекті Telegram-бота під час тестування на платформі Prometheus. Новий проект:

- Не залежить від Python та його тимчасових директорій
- Використовує ефективну архітектуру для крос-платформної розробки
- Має чисту реалізацію без зайвих залежностей
- Працює в контейнеризованому середовищі без проблем з правами доступу

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

## Docker Usage Guide

### Робота з тегами та версіями

```sh
# Змінити версію тега
docker build -t quay.io/smaystr/multiplatform-app:v1.0.0 .
docker push quay.io/smaystr/multiplatform-app:v1.0.0

# Завантажити контейнер з репозиторію на будь-якій машині
docker pull quay.io/smaystr/multiplatform-app:v1.0.0

# Запустити контейнер
docker run quay.io/smaystr/multiplatform-app:v1.0.0

# Запустити з передачею змінних середовища (при необхідності)
docker run -e VARIABLE_NAME=value quay.io/smaystr/multiplatform-app:v1.0.0
# або
docker run --env-file .env quay.io/smaystr/multiplatform-app:v1.0.0

# Видалити старий тег локально
docker rmi quay.io/smaystr/multiplatform-app:v0.9.0

# Ретег існуючого образу
docker tag quay.io/smaystr/multiplatform-app:v0.9.0 quay.io/smaystr/multiplatform-app:v1.0.0
docker push quay.io/smaystr/multiplatform-app:v1.0.0

# Збірка і запуск для швидкого тестування
docker build -t multiplatform-app:latest .
docker run multiplatform-app:latest

# Запуск мультиархітектурного образу
docker run --platform linux/arm64 quay.io/smaystr/multiplatform-app:latest
```

## Очистка

```sh
# Видалення бінарних файлів і Docker-образів
make clean
```

## Особливості реалізації

- **Чиста архітектура**: проект не має зайвих залежностей та використовує стандартну бібліотеку Go
- **Ефективний Dockerfile**: використовує багатоетапну збірку та базується на офіційному образі quay.io/projectquay/golang
- **Підтримка багатьох архітектур**: оптимізовано для роботи на AMD64 та ARM64
- **Автоматизація збірки**: детальний Makefile з численними цілями для різних сценаріїв

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