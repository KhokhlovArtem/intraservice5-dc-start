# Стадия загрузки и подготовки
FROM alpine AS preparer
RUN apk add --no-cache wget unzip
WORKDIR /download
RUN wget -q https://storage.yandexcloud.net/intraservice-distr/5.4.7-linux-agent.zip -O site-agent.zip && \
    unzip -q site-agent.zip && \
    rm site-agent.zip

# Финальная стадия
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Устанавливаем gettext для envsubst
RUN apt-get update && \
    apt-get install -y gettext && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/intraservice-agent

# Копируем содержимое из подготовленной стадии
COPY --from=preparer /download/agent/ .

# Копируем шаблон appsettings.json
COPY appsettings.template.json /appsettings.template.json

EXPOSE 5002

# Генерируем appsettings.json и запускаем приложение в одной команде
CMD ["/bin/bash", "-c", "envsubst < /appsettings.template.json > /var/www/intraservice-agent/appsettings.json && \
  echo 'appsettings.json generated successfully' && exec dotnet /var/www/intraservice-agent/IntraService.Agent.dll "]
