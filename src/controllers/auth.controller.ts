import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import pool from '../config/db';
import admin from '../config/firebase';

const JWT_SECRET = process.env.JWT_SECRET as string;

export const registerUser = async (req: Request, res: Response) => {
    const {username, email, password} = req.body;
    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        await pool.query(
          'INSERT INTO users (username, email, password) VALUES ($1, $2, $3)', 
          [username, email, hashedPassword]  
        );
        res.status(201).json({message: "User created"});
    } catch (err) {
        res.status(500).json({message: "" + err});
    }
};

export const loginUser = async (req: Request, res: Response) => {
  const { identifier, password } = req.body; 
  try {
    const result = await pool.query(
      'SELECT * FROM users WHERE email = $1 OR username = $1', 
      [identifier]
    );
    const user = result.rows[0];

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = jwt.sign({ id: user.id, username: user.username, email: user.email }, JWT_SECRET, { expiresIn: '1h' });
    res.status(200).json({ 
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email
      }
    });
  } catch (err) {
    res.status(500).json({ error: 'Server error: ' + err });
  }
};


// Check if username exists
export const checkUsername = async (req: Request, res: Response) => {
  const { username } = req.params;
  
  if (!username) {
    return res.status(400).json({ error: 'Username is required' });
  }

  try {
    const result = await pool.query(
      'SELECT username FROM users WHERE username = $1',
      [username]
    );
    
    const exists = result.rows.length > 0;
    
    res.json({
      username,
      exists,
      available: !exists
    });
  } catch (err: any) {
    console.error('Username check error:', err);
    res.status(500).json({ error: 'Server error: ' + err.message });
  }
};

// Check if email exists
export const checkEmail = async (req: Request, res: Response) => {
  const { email } = req.params;
  
  if (!email) {
    return res.status(400).json({ error: 'Email is required' });
  }

  try {
    const result = await pool.query(
      'SELECT email FROM users WHERE email = $1',
      [email]
    );
    
    const exists = result.rows.length > 0;
    
    res.json({
      email,
      exists,
      available: !exists
    });
  } catch (err: any) {
    console.error('Email check error:', err);
    res.status(500).json({ error: 'Server error: ' + err.message });
  }
};

// Alternative: Check both username and email in one endpoint
export const checkAvailability = async (req: Request, res: Response) => {
  const { username, email } = req.query;
  
  if (!username && !email) {
    return res.status(400).json({ error: 'Username or email is required' });
  }

  try {
    let result;
    
    if (username && email) {
      result = await pool.query(
        'SELECT username, email FROM users WHERE username = $1 OR email = $2',
        [username, email]
      );
    } else if (username) {
      result = await pool.query(
        'SELECT username FROM users WHERE username = $1',
        [username]
      );
    } else {
      result = await pool.query(
        'SELECT email FROM users WHERE email = $1',
        [email]
      );
    }
    
    const foundUser = result.rows[0];
    
    const response: any = {};
    
    if (username) {
      response.username = {
        value: username,
        exists: foundUser && foundUser.username === username,
        available: !(foundUser && foundUser.username === username)
      };
    }
    
    if (email) {
      response.email = {
        value: email,
        exists: foundUser && foundUser.email === email,
        available: !(foundUser && foundUser.email === email)
      };
    }
    
    res.json(response);
  } catch (err: any) {
    console.error('Availability check error:', err);
    res.status(500).json({ error: 'Server error: ' + err.message });
  }
};

export const firebaseLogin = async (req: Request, res: Response) => {
  const { idToken, email, name, photoURL, uid } = req.body;

  if (!idToken) {
    return res.status(400).json({ error: 'ID token is required' });
  }

  try {
    // Verify the Firebase ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    
    // Check if UID from token matches the one sent in request
    if (decodedToken.uid !== uid) {
      return res.status(401).json({ error: 'Invalid token' });
    }

    // Check if user exists in our database
    const userResult = await pool.query(
      'SELECT * FROM users WHERE firebase_uid = $1',
      [uid]
    );

    let user = userResult.rows[0];
    
    if (!user) {
      // User doesn't exist, create a new user
      // Generate a unique username from email or name
      const baseUsername = (name || email.split('@')[0]).toLowerCase().replace(/\s+/g, '');
      let username = baseUsername;
      let usernameExists = true;
      let counter = 1;
      
      // Keep trying until we find a unique username
      while (usernameExists) {
        const usernameCheck = await pool.query(
          'SELECT username FROM users WHERE username = $1',
          [username]
        );
        
        if (usernameCheck.rows.length === 0) {
          usernameExists = false;
        } else {
          username = `${baseUsername}${counter}`;
          counter++;
        }
      }
      
      // Create the user
      const newUserResult = await pool.query(
        `INSERT INTO users (
          username, 
          email, 
          password, 
          firebase_uid, 
          profile_picture
        ) VALUES ($1, $2, $3, $4, $5) RETURNING *`,
        [
          username,
          email,
          // Generate a random password for these users since they won't use it
          await bcrypt.hash(Math.random().toString(36).slice(-10), 10),
          uid,
          photoURL || null
        ]
      );
      
      user = newUserResult.rows[0];
    } else {
      // User exists, update their information if needed
      await pool.query(
        `UPDATE users SET 
          email = $1, 
          profile_picture = $2
        WHERE firebase_uid = $3`,
        [email, photoURL || null, uid]
      );
    }

    // Generate our own JWT token
    const token = jwt.sign(
      { 
        id: user.id, 
        username: user.username, 
        email: user.email,
        firebase_uid: user.firebase_uid
      }, 
      JWT_SECRET, 
      { expiresIn: '7d' }
    );

    // Return the token and user data
    res.status(200).json({
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        profilePicture: user.profile_picture
      }
    });
  } catch (error: any) {
    console.error('Firebase authentication error:', error);
    res.status(401).json({ error: 'Invalid Firebase token: ' + error.message });
  }
};