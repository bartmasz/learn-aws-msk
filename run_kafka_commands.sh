#!/bin/bash

# IAM
export BS="url_here" # without port 
# create topic
./kafka-topics.sh --create --bootstrap-server "${BS}:9098" --replication-factor 3 --partitions 1 --command-config ./client.properties  --topic test-topic-iam
# describe topic
./kafka-topics.sh --bootstrap-server "${BS}:9098" --command-config ./client.properties --describe test-topic-iam
# start producer
./kafka-console-producer.sh --bootstrap-server "${BS}:9098" --producer.config ./client.properties --topic test-topic-iam
# start consumer
./kafka-console-consumer.sh --bootstrap-server "${BS}:9098" --consumer.config ./client.properties --topic test-topic-iam --from-beginning
# performance testing
./kafka-producer-perf-test.sh --topic test-topic-iam --num-records 100000 --throughput 100000 --producer.config client.properties --payload-file ~/payload.txt --producer-props bootstrap.servers="$BS:9098"
./kafka-consumer-perf-test.sh --consumer.config client.properties --topic test-topic-iam --bootstrap-server "${BS}:9098" --messages 100000