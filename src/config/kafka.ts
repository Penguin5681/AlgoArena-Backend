import { Kafka } from 'kafkajs';
import dotenv from 'dotenv';

dotenv.config();

export const kafka = new Kafka({
    clientId: 'algoarena-backend',
    brokers: [process.env.KAFKA_BROKER || 'localhost:9092'],
});

export const producer = kafka.producer();

export const initializeKafka = async () => {
    try {
        await producer.connect();
        console.log('Kafka producer connected');
    } catch (error) {
        console.error('Failed to connect to Kafka:', error);
    }
};

process.on('SIGINT', async () => {
    await producer.disconnect();
    process.exit(0);
});