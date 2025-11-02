# intraservice5-dc-start



# tree 
├── app
│   ├── appsettings.template.json
│   └── Dockerfile
├── app-agent
│   ├── appsettings-agent.template.json
│   └── Dockerfile
├── appsettings-agent.template.json
├── appsettings.template.json
├── docker-compose.yml
├── README.md
└── start-dc.sh

# Запуск IntraService с использованием Docker Compose

## 1. Настройка переменных окружения

## 2. Dockerfile

app - dotnet IntraService.dll

app-agent - dotnet IntraService.Agent.dll

## 3. Docker Compose конфигурация
docker compose up -d --build

## 4. Запуск приложения

## 5. Проверка работоспособности

## 6. Мониторинг и логи

## 7. Обновление приложения
