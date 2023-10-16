#!/bin/bash
sudo hostnamectl set-hostname ${nodename}

sudo apt update
sudo apt install -y openjdk-11-jre-headless

#export msk_version="3.5.1"

sudo wget https://archive.apache.org/dist/kafka/${msk_version}/kafka_2.13-${msk_version}.tgz -O /home/ubuntu/kafka.tgz

sudo mkdir -p /home/ubuntu/kafka
sudo tar -xzf /home/ubuntu/kafka.tgz -C /home/ubuntu/kafka --strip-components=1
sudo rm -f /home/ubuntu/kafka.tgz

sudo wget https://github.com/aws/aws-msk-iam-auth/releases/download/v1.1.9/aws-msk-iam-auth-1.1.9-all.jar -O /home/ubuntu/kafka/libs/aws-msk-iam-auth-1.1.9-all.jar

sudo cat << EOF > /home/ubuntu/kafka/bin/client.properties
security.protocol=SASL_SSL
sasl.mechanism=AWS_MSK_IAM
sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
EOF

sudo chown -R ubuntu:ubuntu /home/ubuntu/kafka

