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
  description = "ID do Security Group criado para os bancos"
  value = aws_security_group.sg.id
}

# Outputs completos para strings de conexão
output "postgres_connection_string" {
  description = "String de conexão completa do PostgreSQL"
  value       = "postgresql://${aws_db_instance.rds_postgres.username}:${aws_db_instance.rds_postgres.password}@${aws_db_instance.rds_postgres.endpoint}:${aws_db_instance.rds_postgres.port}/${aws_db_instance.rds_postgres.db_name}"
  sensitive   = true
}

# Outputs para MongoDB
output "mongodb_endpoint" {
  description = "Endpoint do MongoDB no EKS"
  value = kubernetes_service.mongodb.status[0].load_balancer[0].ingress[0].hostname
}

output "mongodb_port" {
  description = "Porta do MongoDB"
  value = 27017
}

output "mongodb_username" {
  description = "Usuário do MongoDB"
  value = "dev_user"
}

output "mongodb_password" {
  description = "Senha do MongoDB"
  value = var.mongodb_admin_password
  sensitive = true
}

output "mongodb_database" {
  description = "Nome do banco de dados do MongoDB"
  value = "FoodOrder_Cardapio"
}

output "mongodb_connection_string" {
  description = "String de conexão completa do MongoDB"
  value = "mongodb://${aws_db_instance.rds_postgres.username}:${var.mongodb_admin_password}@${kubernetes_service.mongodb.status[0].load_balancer[0].ingress[0].hostname}:27017/FoodOrder_Cardapio"
  sensitive = true
}
