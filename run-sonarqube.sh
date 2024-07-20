#!/bin/sh
set -e

# Carregar variáveis do arquivo .env
export $(grep -v '^#' .env | xargs)

# Levantando os containers do Docker
# docker compose up

# Aguarda alguns segundos para garantir que o SonarQube esteja pronto
echo "Inicializando o SonarQube Scanner..."
sleep 5

# Verificar se a variável RUN_SONARQUBE é verdadeira
if [ "$RUN_SONARQUBE" = "true" ]; then

  # Debug: Imprimir variáveis de ambiente
  echo "SONARQUBE_HOST_URL=${SONARQUBE_HOST_URL}"
  echo "SONARQUBE_PROJECT_NAME=${SONARQUBE_PROJECT_NAME}"
  echo "SONARQUBE_PROJECT_TOKEN=${SONARQUBE_PROJECT_TOKEN}"
  echo "SRC_DIR=$(pwd)/src"

  # Executa o SonarQube Scanner e salva o resultado
  RESULT=$(docker run --rm --network=host -e SONAR_HOST_URL=${SONARQUBE_HOST_URL} -v $(pwd)/src:/usr/src sonarsource/sonar-scanner-cli \
    -Dsonar.projectKey=${SONARQUBE_PROJECT_NAME} \
    -Dsonar.sources=. \
    -Dsonar.host.url=${SONARQUBE_HOST_URL} \
    -Dsonar.login=${SONARQUBE_PROJECT_TOKEN} \
    -Dsonar.issuesReport.html.enable=true \
    -Dsonar.issuesReport.html.location=$(pwd)/sonar-reports/ || echo "fail")

  # Para os containers do Docker após a execução
  # docker compose down

  # Verifica o resultado e sai com um código de erro se falhou
  if [ "$RESULT" = "fail" ]; then
    echo "SonarQube encontrou problemas no código. Corrija-os antes de fazer o push."
    exit 1
  fi

  echo "Finalizado o SonarQube Scanner!"

else 
 echo "RUN_SONARQUBE is not set to true. Skipping SonarQube scan."
fi
