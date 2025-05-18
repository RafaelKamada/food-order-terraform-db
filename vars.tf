variable "regionDefault" {
  default = "us-east-1"
}

variable "projectName" {
  default = "EKS-FOOD-ORDER-DB"
}

variable "rds_postgres"{
    default = "eks-rds-postgres"
}

variable "rdsName" {
  default = "food-order-db"
}

variable "eks_cluster" {
  description = "Nome do cluster EKS"
  default     = "EKS-FOOD-ORDER-DB"
}

variable "labRole" {
  default = "arn:aws:iam::276201098979:role/LabRole"
}

variable "instanceType" {
  default = "db.t3.medium"
}

variable "principalArn" {
  default = "arn:aws:iam::276201098979:role/voclabs"
}

variable "rds_arn" {
  default = "arn:aws:rds:us-east-1:276201098979::db:rdsName"
}

# Security Group compartilhado para RDS e MongoDB
variable "db_security_group_id" {
  description = "ID do Security Group criado na infraestrutura principal"
  default = "sg-054a6a3108c1929b1"
}

variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}


variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "foodorderdb"
}

variable "db_username" {
  description = "Username do banco de dados"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  default     = "postgres"
}
