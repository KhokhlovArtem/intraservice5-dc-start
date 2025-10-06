# Загружаем переменные в текущую сессию
export $(grep -v '^#' .env | xargs)

# Запускаем
docker-compose up -d

# Проверить, что appsettings.json правильно сконфигурирован в контейнере
docker exec intraservice-container cat /var/www/intraservice/appsettings.json

# Проверить логи на предмет ошибок подключения к БД
docker logs intraservice-container

# Проверить переменные окружения
docker exec intraservice-container printenv