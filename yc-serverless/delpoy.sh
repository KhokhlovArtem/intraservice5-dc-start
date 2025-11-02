# Создаем serverless containers
yc serverless container create --name intraservice-app --from-file app-container.yaml
yc serverless container create --name intraservice-agent --from-file agent-container.yaml

# Создаем ревизии
yc serverless container deploy --name intraservice-app --image cr.yandex/<registry-id>/intraservice-app:latest
yc serverless container deploy --name intraservice-agent --image cr.yandex/<registry-id>/intraservice-agent:latest