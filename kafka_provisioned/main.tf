resource "aws_cloudwatch_log_group" "msk_test" {
  name = "msk_broker_logs"
}

resource "aws_s3_bucket" "msk_bucket" {
  bucket = "libator-msk-broker-logs-bucket"
}

resource "aws_s3_bucket_acl" "msk_bucket_acl" {
  bucket = aws_s3_bucket.msk_bucket.id
  acl    = "private"
}

resource "aws_msk_configuration" "msk_config" {
  kafka_versions = [var.msk_version]
  name           = "${var.kafka_cluster_name}-config"

  server_properties = <<PROPERTIES
num.partitions=3
log.retention.minutes=2
PROPERTIES
}

resource "aws_msk_cluster" "example" {
  cluster_name           = "${var.kafka_cluster_name}-provisioned"
  kafka_version          = var.msk_version
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type  = var.broker_instance_type
    client_subnets = var.private_subnets
    storage_info {
      ebs_storage_info {
        # provisioned_throughput {
        #   enabled           = true
        #   volume_throughput = 250
        # }
        volume_size = var.broker_storage_gb
      }
    }
    security_groups = var.private_sg
  }

  configuration_info {
    arn      = aws_msk_configuration.msk_config.arn
    revision = aws_msk_configuration.msk_config.latest_revision
  }

  client_authentication {
    sasl {
      iam = true
    }
    unauthenticated = false
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk_test.name
      }
      s3 {
        enabled = true
        bucket  = aws_s3_bucket.msk_bucket.id
        prefix  = "logs/msk-"
      }
    }
  }

  tags = {
    Type = "provisioned"
  }
}