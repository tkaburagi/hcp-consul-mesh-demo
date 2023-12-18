module "front_ecs" {
  source              = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version             = "0.7.0"
  consul_server_hosts = var.consul_server_hosts
  consul_service_name = "front_ecs"
  acls                = true
  tls                 = true
  http_config = {
    port  = 443
    https = true
  }
  grpc_config = {
    port = 8502
  }
  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.log_group.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "kabu_front_ecs"
    }
  }
  family = "kabu_front_ecs"
  container_definitions = [
    {
      name      = "ecs-go"
      image     = "public.ecr.aws/l7i6h0r0/echo-ecs:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "SVC_LOCATION",
          value = "http://127.0.0.1:5000"
        },
        {
          name  = "MESSAGE",
          value = "I'm running on ECS: "
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.log_group.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "kabu_front_ecs"
        }
      }
      cpu         = 0
      mountPoints = []
      volumesFrom = []
    }
  ]
  port = 8080
  upstreams = [
    {
      destinationName = "echo-eks-service"
      localBindPort   = 5000
    }
  ]
}

resource "aws_ecs_service" "front_ecs" {
  name            = "kabu_front_ecs_svc"
  cluster         = var.ecs_cluster_arn
  task_definition = module.front_ecs.task_definition_arn
  desired_count   = 1

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.sg
    assign_public_ip = true
  }

  launch_type            = "FARGATE"
  propagate_tags         = "TASK_DEFINITION"
  enable_execute_command = true
}

module "controller" {
  source  = "hashicorp/consul-ecs/aws//modules/controller"
  version = "0.7.0"

  # Address of the Consul server
  consul_server_hosts = var.consul_server_hosts

  # Configures TLS for the mesh-task.
  tls = true

  # The HCP Consul HTTP with TLS API port
  http_config = {
    port  = 443
    https = true
  }

  # The HCP Consul gRPC with TLS API port
  grpc_config = {
    port = 8502
  }

  # The ARN of the AWS SecretsManager secret containing the token to be used by this controller. 
  # The token needs to have at least `acl:write`, `node:write` and `operator:write` privileges in Consul
  consul_bootstrap_token_secret_arn = aws_secretsmanager_secret.bootstrap_token.arn

  name_prefix      = "kabu-demo-chugai"
  ecs_cluster_arn  = var.ecs_cluster_arn
  region           = var.region
  subnets          = var.subnets
  security_groups  = var.sg
  assign_public_ip = true
  launch_type      = "FARGATE"
  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.log_group.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "controller"
    }
  }
}

resource "aws_secretsmanager_secret" "bootstrap_token" {
  name                    = "kabu-consul-bootstrap-token"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "bootstrap_token" {
  secret_id     = aws_secretsmanager_secret.bootstrap_token.id
  secret_string = var.token
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "kabu-my-log"
}
