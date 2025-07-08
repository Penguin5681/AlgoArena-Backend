import { Request, Response } from 'express';
import {bucket} from '../config/firebase';
import { v4 as uuidv4 } from 'uuid';
import path from 'path';
import pool from '../config/db';

export const uploadProfilePicture = async (req: Request, res: Response) => {
    try {
        const email = req.body.email;
        if (!email) return res.status(400).json({ message: 'Email is required' });
        if (!req.file) return res.status(400).json({ message: 'No file uploaded' });

        const file = req.file;
        const fileName = `profile_pictures/${uuidv4()}${path.extname(file.originalname)}`;
        const fileUpload = bucket.file(fileName);

        const uuid = uuidv4();

        const stream = fileUpload.createWriteStream({
            metadata: {
                contentType: file.mimetype,
                metadata: {
                    firebaseStorageDownloadTokens: uuid,
                },
            },
        });

        stream.on('error', (err: { message: any; }) => {
            console.error(err);
            res.status(500).json({ message: 'Upload error', error: err.message });
        });

        stream.on('finish', async () => {
            const publicUrl = `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(fileName)}?alt=media&token=${uuid}`;
            try {
                await pool.query(
                    `UPDATE users SET profile_picture = $1 WHERE email = $2`,
                    [publicUrl, email]
                );
                return res.status(200).json({ url: publicUrl });
            } catch (dbErr) {
                console.error('DB update error:', dbErr);
                return res.status(500).json({ message: 'DB update failed' });
            }
        });

        stream.end(file.buffer);
    } catch (err: any) {
        console.error(err);
        res.status(500).json({ message: 'Unexpected error', error: err.message });
    }
};
