output "ecstask_arn" {
    value = aws_ecs_task_definition.task_definition.*.arn
}
output "ecstask_efs_arn" {
    value = aws_ecs_task_definition.efs.*.arn
}