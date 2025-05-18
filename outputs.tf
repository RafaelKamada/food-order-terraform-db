output "rds_endpoint" {
  value = aws_db_instance.rds_postgres.endpoint
}

output "rds_port" {
  value = aws_db_instance.rds_postgres.port
}

output "database_name" {
  value = aws_db_instance.rds_postgres.db_name
}

output "vpc_id" {
  value = local.vpc_id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

# Outputs completos para strings de conexão
output "postgres_connection_string" {
  description = "String de conexão completa do PostgreSQL"
  value       = "postgresql://${aws_db_instance.rds_postgres.username}:${aws_db_instance.rds_postgres.password}@${aws_db_instance.rds_postgres.endpoint}:${aws_db_instance.rds_postgres.port}/${aws_db_instance.rds_postgres.db_name}"
  sensitive   = true
}
