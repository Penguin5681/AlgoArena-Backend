import * as admin from 'firebase-admin';
import dotenv from 'dotenv';
import fs from 'fs';

dotenv.config();

let serviceAccount;

if (process.env.FIREBASE_SERVICE_ACCOUNT_PATH) {
  try {
    const rawData = fs.readFileSync(process.env.FIREBASE_SERVICE_ACCOUNT_PATH, 'utf8');
    serviceAccount = JSON.parse(rawData);
    console.log('Successfully loaded Firebase credentials from secret');
  } catch (error) {
    console.error('Error loading Firebase credentials:', error);
    throw new Error(`Failed to load Firebase service account: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }
} else {
  throw new Error('Firebase service account credentials path is missing in environment variables');
}

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

export default admin;