export CONSUL_HTTP_ADDR=xxx
export CONSUL_HTTP_TOKEN=xxx

kubectl create secret generic "consul-bootstrap-token" \
--from-literal="token=xxx" \
--namespace consul

kubectl create secret generic consul-hcp-client-id \
--from-literal="client-id=xxx" \
-n consul

kubectl create secret generic consul-hcp-client-secret \
--from-literal="client-secret=xxx" \
-n consul


kubectl create secret generic consul-hcp-resource-id \
--from-literal="resource-id=organization/xxx/project/xxx/hashicorp.consul.global-network-manager.cluster/consul-cluster-1-16" \
-n consul

helm install consul hashicorp/consul \
--values values-116.yaml \
--namespace consul \
--version "1.2.3"

kc sniff -p echo-eks-7dfff99d9-s8ljs -n default -c consul-dataplane