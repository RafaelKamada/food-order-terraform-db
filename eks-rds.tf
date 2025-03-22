resource "aws_db_instance" "rds_postgres" {
  identifier             = var.rdsName
  engine                 = "postgres"
  instance_class         = var.instanceType
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_encrypted      = true
  multi_az               = true  # Habilita alta disponibilidade
  backup_retention_period = 7    # Mantém backups por 7 dias
  deletion_protection     = false # Impede deleção acidental

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg.id]

  username               = var.username
  password               = var.password

  monitoring_interval    = 0 # Desativa o Monitoring
  performance_insights_enabled = true

  publicly_accessible    = false # Mantém o RDS privado

  tags = {
    Name = "PostgreSQL RDS"
  }
}