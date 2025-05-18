resource "aws_db_instance" "mongodb" {
  identifier             = var.mongodb_name
  engine                 = "mongodb"
  engine_version         = "6.0.10"
  instance_class         = var.instanceType
  allocated_storage      = var.mongodb_allocated_storage
  storage_encrypted      = true
  multi_az              = true
  
  username              = "dev_user"
  password              = var.mongodb_admin_password
  
  db_name               = "FoodOrder_Cardapio"
  
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg.id]
  publicly_accessible    = false

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"
  
  monitoring_interval    = 0
  performance_insights_enabled = true
  
  deletion_protection    = false
  skip_final_snapshot    = true

  tags = {
    Name        = "MongoDB RDS"
    Environment = "production"
  }
}

output "mongodb_arn" {
  value = aws_db_instance.mongodb.arn
}

output "mongodb_endpoint" {
  value = aws_db_instance.mongodb.endpoint
}

output "mongodb_connection_string" {
  value = "mongodb://${aws_db_instance.mongodb.endpoint}:27017/FoodOrder_Cardapio"
}
