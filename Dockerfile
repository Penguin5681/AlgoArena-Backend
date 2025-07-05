FROM node:20-slim

RUN apt-get update && \
    apt-get install -y wget openjdk-17-jre-headless netcat-traditional 1.10-48 && \
    rm -rf /var/lib/apt/lists/*

ENV KAFKA_VERSION=3.7.0
ENV SCALA_VERSION=2.13
RUN wget https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    tar -xzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    mv kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka && \
    rm kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN chmod +x ./start-services.sh

EXPOSE 9092 2181 3000

CMD ["./start-services.sh"]
