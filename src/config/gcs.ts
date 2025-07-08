import { Storage } from '@google-cloud/storage';
import path from 'path';

const gc = new Storage({
  keyFilename: process.env.GCLOUD_SERVICE_KEY_PATH, 
  projectId: process.env.GCLOUD_PROJECT_ID,
});

const bucketName = process.env.GCLOUD_BUCKET_NAME!;
const bucket = gc.bucket(bucketName);

export default bucket;
