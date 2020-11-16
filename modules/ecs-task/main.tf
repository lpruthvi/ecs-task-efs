
resource "aws_ecs_task_definition" "task_definition" {
  count                    = var.efs_enable ? 0 : 1
  family                   = var.ecs_task_name 
  container_definitions    = file(var.file_task_definition)                                                                                                                                                                       
  network_mode             = var.ecs_network_mode                                                                                      
  requires_compatibilities = ["EC2"]                                                                                       
  task_role_arn            = var.task_role_arn  
  execution_role_arn           = var.task_role_arn                                                              
} 


### With Efs Enabled ####

resource "aws_ecs_task_definition" "efs" {
  count                    = var.efs_enable ? 1 : 0
  family                   = var.ecs_task_name 
  container_definitions    = file(var.file_task_definition)                                                                                                                                                                       
  network_mode             = var.ecs_network_mode                                                                                      
  requires_compatibilities = ["EC2"]                                                                                       
  execution_role_arn           = var.task_role_arn
  task_role_arn            = var.task_role_arn    
   volume {
    name      = var.ecs_volume_name
    efs_volume_configuration {
      file_system_id = element(var.efs_id, count.index)
      transit_encryption      = "ENABLED"
       authorization_config {
        access_point_id = element(var.aws_efs_access_point_id, count.index)
      }
    }
  } 
  depends_on = [var.aws_efs_access_point_id]                                                                 
} 
