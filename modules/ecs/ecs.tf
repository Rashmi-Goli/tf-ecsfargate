resource "aws_ecs_cluster" "ecs-app1" {
  name = "appOne"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "ecsTaskDef" {
  family                   = "appone"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.taskExecutionRole.arn
  container_definitions    = <<TASK_DEFINITION
    [
    {
        "name": "appOneContainer",
        "image": "630315683075.dkr.ecr.us-east-1.amazonaws.com/demoapp:latest",
                  
        "portMappings": [
            {
             "containerPort": 8080
            }
        ],
        
        "essential": true
    }
    ]
TASK_DEFINITION
  //"cpu": 1024,
  //       "memory": 2048,
  # runtime_platform {
  #   operating_system_family = "WINDOWS_SERVER_2019_CORE"
  #   cpu_architecture        = "X86_64"
  # }
}

resource "aws_ecs_service" "ecsService" {
  name            = "appOne-ecsService"
  cluster         = aws_ecs_cluster.ecs-app1.id
  task_definition = aws_ecs_task_definition.ecsTaskDef.arn
  desired_count   = 1
 # iam_role        = aws_iam_role.taskExecutionRole.arn
  launch_type     = "FARGATE"
  network_configuration {
    assign_public_ip = true
    security_groups  = [var.secGroupID]
    subnets          = [var.subnet_id]

  }
  # depends_on      = [aws_iam_role_policy.foo]

}

