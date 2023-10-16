resource "aws_msk_serverless_cluster" "msk_serverless" {
  cluster_name = "${var.kafka_cluster_name}-serverless"

  vpc_config {

    subnet_ids         = var.private_subnets
    security_group_ids = var.private_sg
  }

  client_authentication {
    sasl {
      iam {
        enabled = true
      }
    }
  }

  tags = {
    Type = "Serverless"
  }

  provisioner "local-exec" {
    command = "echo Kafka serverless ARN: ${self.arn} && aws kafka get-bootstrap-brokers --cluster-arn '${self.arn}'"
  }
}