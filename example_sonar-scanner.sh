docker run \
--rm \
--network=host \
-e SONAR_HOST_URL=http://localhost:9000 \
-v ./src:/usr/src \
sonarsource/sonar-scanner-cli \
-Dsonar.projectKey=test \
-Dsonar.sources=. \
-Dsonar.host.url=http://localhost:9000 \
-Dsonar.login=sqp_495bdac2d9df6c43712e32ed21671c0c99e7d22e
