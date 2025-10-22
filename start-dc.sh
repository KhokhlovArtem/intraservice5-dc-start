# Загружаем переменные в текущую сессию
export $(grep -v '^#' .env | xargs)

# Сборка и запуск
docker compose up -d --build

# Только запуск
docker compose up -d

# Проверить, что appsettings.json правильно сконфигурирован в контейнере
docker exec intraservice-app cat /var/www/intraservice/appsettings.json
docker exec intraservice-agent cat /var/www/intraservice/appsettings.json

# Проверить логи на предмет ошибок подключения к БД
docker logs intraservice-app
docker logs intraservice-agent

или 

docker compose logs -f

# Проверить переменные окружения
docker exec intraservice-app printenv
docker exec intraservice-agent printenv

# Выключение
docker compose down
