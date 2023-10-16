locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "Security Group for Public Access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
          self_val    = false
        }
      }
    }
    private = {
      name        = "private_sg"
      description = "Security Group for Private Kafka Access"
      ingress = {
        self_reference = {
          from        = 0
          to          = 0
          protocol    = "-1"
          cidr_blocks = []
          self_val    = true
        }
      }
    }
  }
}