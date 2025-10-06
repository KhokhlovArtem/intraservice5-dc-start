# intraservice5-dc-start


# TODO
project-root/
+ appsettings.json.j2          # Шаблон конфигурации
├── appsettings.json             # Сгенерированный файл (не в git)
+ env.yml                      # Переменные окружения
+ .env                         # Docker переменные
├── parse_env.sh                 # Парсер YAML
├── setup-container.sh           # Скрипт запуска
├── Dockerfile
├── docker-compose.yml
└── .dockerignore

+Distr
├── 5.4.7.site/
│   ├── IntraService.dll
│   └── ... (другие файлы)



# Запуск IntraService с использованием Docker Compose

## Структура проекта

```
intraservice-docker/
├── docker-compose.yml
├── .env
├── Dockerfile
└── 5.4.7.site/
    ├── IntraService.dll
    ├── *.dll
    └── *.json
```

## 1. Настройка переменных окружения

Создайте файл `.env` в корне проекта:

```env
# Настройки базы данных
DB_HOST=your-database-host
DB_PORT=6432
DB_NAME=intraservice_db
DB_USER=intraservice_user
DB_PASS=your_secure_password

# URL приложений
INTRASERVICE_URL=https://your-intraservice-domain.com
AGENT_URL=https://your-agent-domain.com

# Настройки Docker
EXTERNAL_PORT=5001
INTERNAL_PORT=5001
```

## 2. Dockerfile

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:6.0

WORKDIR /var/www/intraservice

# Копируем приложение
COPY ./5.4.7.site/ .

EXPOSE 5001

# Переменные окружения
ENV ASPNETCORE_ENVIRONMENT=Production
ENV DOTNET_PRINT_TELEMETRY_MESSAGE=false
ENV ASPNETCORE_URLS=http://localhost:5001

ENTRYPOINT ["dotnet", "/var/www/intraservice/IntraService.dll"]
```

## 3. Docker Compose конфигурация

Создайте `docker-compose.yml`:

```yaml
version: '3.8'

services:
  intraservice:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "${EXTERNAL_PORT}:${INTERNAL_PORT}"
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - DOTNET_PRINT_TELEMETRY_MESSAGE=false
      - ASPNETCORE_URLS=http://localhost:${INTERNAL_PORT}
      - DbName=${DB_NAME}
      - DB_HOST=${DB_HOST}
      - DB_PORT=${DB_PORT}
      - DB_USER=${DB_USER}
      - DB_PASS=${DB_PASS}
      - IntraServiceUrl=${INTRASERVICE_URL}
      - AgentUrl=${AGENT_URL}
    env_file:
      - .env
    restart: unless-stopped
    container_name: intraservice-app
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:${INTERNAL_PORT}/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## 4. Запуск приложения

### Первоначальный запуск:
```bash
# Сборка и запуск
docker-compose up -d

# Просмотр логов
docker-compose logs -f

# Проверка статуса
docker-compose ps
```

### Управление сервисом:
```bash
# Остановка
docker-compose down

# Перезапуск
docker-compose restart

# Обновление (после изменений в коде)
docker-compose up -d --build

# Просмотр логов
docker-compose logs -f intraservice

# Проверка health status
docker-compose ps
```

## 5. Проверка работоспособности

```bash
# Проверка доступности приложения
curl http://localhost:5001

# Проверка логов
docker-compose logs intraservice

# Проверка healthcheck
docker inspect --format='{{.State.Health.Status}}' intraservice-app

# Вход в контейнер для отладки
docker-compose exec intraservice /bin/bash
```

## 6. Мониторинг и логи

```bash
# Просмотр логов в реальном времени
docker-compose logs -f intraservice

# Статистика использования ресурсов
docker stats intraservice-app

# Информация о контейнере
docker inspect intraservice-app
```

## 7. Обновление приложения

При обновлении файлов в каталоге `5.4.7.site`:

```bash
# Пересборка и перезапуск
docker-compose up -d --build

# Или пошагово
docker-compose down
docker-compose up -d --build
```

## 8. Безопасность

```bash
# Проверка на уязвимости образа
docker scan intraservice-app

# Просмотр запущенных процессов
docker-compose top
```

## Преимущества данного подхода:

1. **Простота управления** - одна команда для запуска/остановки
2. **Централизованная конфигурация** - все настройки в `.env` файле
3. **Автоматический перезапуск** - при сбоях контейнер перезапускается
4. **Health monitoring** - встроенная проверка здоровья приложения
5. **Логирование** - централизованное управление логами
6. **Воспроизводимость** - идентичная среда на всех стендах

Приложение будет доступно по адресу: `http://localhost:5001`