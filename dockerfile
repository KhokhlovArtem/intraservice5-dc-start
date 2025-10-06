# Используем официальный образ ASP.NET 6
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Устанавливаем рабочую директорию
WORKDIR /var/www/intraservice

# Копируем содержимое каталога 5.4.7.site в контейнер
COPY ./distr/5.4.7.site/ .

# Копируем подготовленный appsettings.json
COPY appsettings.json ./appsettings.json

# Открываем порт, который использует приложение
EXPOSE 5001

# Устанавливаем переменные окружения
ENV ASPNETCORE_ENVIRONMENT=Production
ENV DOTNET_PRINT_TELEMETRY_MESSAGE=false
ENV ASPNETCORE_URLS=http://localhost:5001

# Запускаем приложение
ENTRYPOINT ["dotnet", "/var/www/intraservice/IntraService.dll"]