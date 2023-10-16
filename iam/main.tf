data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


resource "aws_iam_policy" "kafka_access_policy" {
  name        = "kafka_access_policy"
  path        = "/"
  description = "Policy granting acess to Kafka Cluster"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "kafka-cluster:Connect",
          "kafka-cluster:AlterCluster",
          "kafka-cluster:DescribeCluster"
        ],
        "Resource" : [
          "arn:aws:kafka:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${var.kafka_cluster_name}*/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kafka-cluster:*Topic*",
          "kafka-cluster:WriteData",
          "kafka-cluster:ReadData"
        ],
        "Resource" : [
          "arn:aws:kafka:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topic/${var.kafka_cluster_name}*/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup"
        ],
        "Resource" : [
          "arn:aws:kafka:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:group/${var.kafka_cluster_name}*/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "kafka_access_role" {
  name = "kafka_access_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_policy_attachment" "kafka_access_policy_attachment" {
  name       = "Kafka policy attachement"
  policy_arn = aws_iam_policy.kafka_access_policy.arn
  roles      = [aws_iam_role.kafka_access_role.name]
}

# Create an IAM instance profile
resource "aws_iam_instance_profile" "kafka_profile" {
  name = "kafka-profile-name"
  role = aws_iam_role.kafka_access_role.name
}