#!/bin/bash

# Start Zookeeper
/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties &
ZOOKEEPER_PID=$!

# Wait for Zookeeper to be ready
while ! nc -z localhost 2181; do
  sleep 1
done

# Start Kafka
/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties &
KAFKA_PID=$!

# Wait for Kafka to be ready
while ! nc -z localhost 9092; do
  sleep 1
done

# Start Node app
npx nodemon src/index.ts

# Optional: Wait for background processes (if needed)
wait $ZOOKEEPER_PID
wait $KAFKA_PID