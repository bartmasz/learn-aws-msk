output "zookeeper_connect_string" {
  value = aws_msk_cluster.example.zookeeper_connect_string
}

output "bootstrap_brokers_iam" {
  description = "IAM connection host:port pairs"
  value       = aws_msk_cluster.example.bootstrap_brokers_sasl_iam
}