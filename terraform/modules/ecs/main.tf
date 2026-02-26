resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster-nandini"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-task-nandini"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = var.image_uri

      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
      environment = [
        {
            name = "HOST"
            value = "0.0.0.0"
        },
        {
            name = "PORT",
            value = "1337"
        },
        {
            name  = "NODE_ENV"
            value = "production"
        },
        {
            name  = "APP_KEYS"
            value = "key1,key2,key3,key4"
        },
        {
            name  = "API_TOKEN_SALT"
            value = "someRandomSalt123"
        },
        {
            name  = "ADMIN_JWT_SECRET"
            value = "adminSecret123"
        },
        {
            name  = "JWT_SECRET"
            value = "jwtSecret123"
        },
        {
            name  = "DATABASE_CLIENT"
            value = "postgres"
        },
        {
            name  = "DATABASE_HOST"
            value = var.db_host
        },
        {
            name  = "DATABASE_PORT"
            value = "5432"
        },
        {
            name  = "DATABASE_NAME"
            value = var.db_name
        },
        {
            name  = "DATABASE_USERNAME"
            value = var.db_username
        },
        {
            name  = "DATABASE_PASSWORD"
            value = var.db_password
        },
        {
            name  = "DATABASE_SSL"
            value = "true"
        },
        {
            name  = "DATABASE_SSL_REJECT_UNAUTHORIZED",
            value = "false"
        }
      ]
      logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "/ecs/${var.project_name}-nandu"
            awslogs-region        = var.aws_region
            awslogs-stream-prefix = "ecs"
          }
      }
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-service-nandini"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = 180

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.blue_target_group_arn
    container_name   = "strapi"
    container_port   = 1337
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer,
      desired_count
    ]
  }
}