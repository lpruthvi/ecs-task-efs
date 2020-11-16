[
  {
  "name": "db",
    "image": "postgres:11.6",
    "cpu": 0,
    "memoryReservation": 50,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 5432,
        "hostPort": 5432
      }
    ],
    "mountPoints": [
          {
              "containerPath": "/var/lib/postgresql/data",
              "sourceVolume": "psql"
          }
      ],
    "logConfiguration": {
                "logDriver": "awslogs",
                "awslogs-create-group": "true",
                "options": {
                    "awslogs-group": "dev",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "awslogs-node"
                }
            }
  }
]
