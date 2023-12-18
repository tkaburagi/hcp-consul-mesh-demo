#!/bin/sh
cd /Users/kabu/hashicorp/consul/chugai-demo/eks/app/echo-eks
./mvnw clean package -DskipTests
pwd
docker build --platform linux/amd64 -t tkaburagi/echo-ecs .
docker tag tkaburagi/echo-ecs:latest public.ecr.aws/l7i6h0r0/echo-ecs:latest
docker push public.ecr.aws/l7i6h0r0/echo-ecs:latest
pwd