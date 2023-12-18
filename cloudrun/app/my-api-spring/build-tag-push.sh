#!/bin/sh
export PJ_ID=peak-elevator-237302
cd /Users/kabu/hashicorp/consul/chugai-demo/cloudrun/app/my-api-spring
./mvnw clean package -DskipTests
pwd
docker build --platform linux/amd64 -t tkaburagi/my-api-spring .
docker tag tkaburagi/my-api-spring gcr.io/${PJ_ID}/my-api-spring
docker push gcr.io/${PJ_ID}/my-api-spring
pwd