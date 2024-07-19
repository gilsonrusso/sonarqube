#!/bin/sh
set -e

# Levanta os containers do Docker
docker-compose up -d

# Aguarda alguns segundos para garantir que o SonarQube esteja pronto
echo "Aguardando SonarQube inicializar..."
sleep 60

# Executa o SonarQube Scanner e salva o resultado
RESULT=$(docker run --rm --network=host -e SONAR_HOST_URL=http://localhost:9000 -v $(pwd)/src:/usr/src sonarsource/sonar-scanner-cli \
  -Dsonar.projectKey=test \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=sqp_495bdac2d9df6c43712e32ed21671c0c99e7d22e || echo "fail")

# Para os containers do Docker após a execução
docker-compose down

# Verifica o resultado e sai com um código de erro se falhou
if [ "$RESULT" = "fail" ]; then
  echo "SonarQube encontrou problemas no código. Corrija-os antes de fazer o push."
  exit 1
fi
