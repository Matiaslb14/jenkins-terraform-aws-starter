variable "project_name" {
  description = "Tag base del proyecto"
  type        = string
  default     = "jenkins-terraform-aws-starter"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "Nombre del Key Pair existente en la región"
  type        = string
  default     = "my-keypair"
}

variable "ssh_ingress_cidr" {
  description = "CIDR permitido para SSH (usa tu_IP/32)"
  type        = string
  default     = "191.118.18.197/32"
}
