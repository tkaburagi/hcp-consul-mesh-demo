#!/bin/sh
cd /Users/kabu/hashicorp/consul/chugai-demo/eks/app/echo-eks
./mvnw clean package -DskipTests
pwd
docker build --platform linux/amd64 -t tkaburagi/echo-eks .
docker tag tkaburagi/echo-eks:latest public.ecr.aws/l7i6h0r0/echo-eks:latest
docker push public.ecr.aws/l7i6h0r0/echo-eks:latest
pwd