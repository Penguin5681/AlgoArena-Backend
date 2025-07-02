"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.firebaseLogin = exports.checkAvailability = exports.checkEmail = exports.checkUsername = exports.loginUser = exports.registerUser = void 0;
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const db_1 = __importDefault(require("../config/db"));
const firebase_1 = __importDefault(require("../config/firebase"));
const JWT_SECRET = process.env.JWT_SECRET;
const registerUser = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { username, email, password } = req.body;
    try {
        const hashedPassword = yield bcryptjs_1.default.hash(password, 10);
        yield db_1.default.query('INSERT INTO users (username, email, password) VALUES ($1, $2, $3)', [username, email, hashedPassword]);
        res.status(201).json({ message: "User created" });
    }
    catch (err) {
        res.status(500).json({ message: "" + err });
    }
});
exports.registerUser = registerUser;
const loginUser = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { identifier, password } = req.body;
    try {
        const result = yield db_1.default.query('SELECT * FROM users WHERE email = $1 OR username = $1', [identifier]);
        const user = result.rows[0];
        if (!user || !(yield bcryptjs_1.default.compare(password, user.password))) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }
        const token = jsonwebtoken_1.default.sign({ id: user.id, username: user.username, email: user.email }, JWT_SECRET, { expiresIn: '1h' });
        res.status(200).json({
            token,
            user: {
                id: user.id,
                username: user.username,
                email: user.email
            }
        });
    }
    catch (err) {
        res.status(500).json({ error: 'Server error: ' + err });
    }
});
exports.loginUser = loginUser;
// Check if username exists
const checkUsername = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { username } = req.params;
    if (!username) {
        return res.status(400).json({ error: 'Username is required' });
    }
    try {
        const result = yield db_1.default.query('SELECT username FROM users WHERE username = $1', [username]);
        const exists = result.rows.length > 0;
        res.json({
            username,
            exists,
            available: !exists
        });
    }
    catch (err) {
        console.error('Username check error:', err);
        res.status(500).json({ error: 'Server error: ' + err.message });
    }
});
exports.checkUsername = checkUsername;
// Check if email exists
const checkEmail = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { email } = req.params;
    if (!email) {
        return res.status(400).json({ error: 'Email is required' });
    }
    try {
        const result = yield db_1.default.query('SELECT email FROM users WHERE email = $1', [email]);
        const exists = result.rows.length > 0;
        res.json({
            email,
            exists,
            available: !exists
        });
    }
    catch (err) {
        console.error('Email check error:', err);
        res.status(500).json({ error: 'Server error: ' + err.message });
    }
});
exports.checkEmail = checkEmail;
// Alternative: Check both username and email in one endpoint
const checkAvailability = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { username, email } = req.query;
    if (!username && !email) {
        return res.status(400).json({ error: 'Username or email is required' });
    }
    try {
        let result;
        if (username && email) {
            result = yield db_1.default.query('SELECT username, email FROM users WHERE username = $1 OR email = $2', [username, email]);
        }
        else if (username) {
            result = yield db_1.default.query('SELECT username FROM users WHERE username = $1', [username]);
        }
        else {
            result = yield db_1.default.query('SELECT email FROM users WHERE email = $1', [email]);
        }
        const foundUser = result.rows[0];
        const response = {};
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
    }
    catch (err) {
        console.error('Availability check error:', err);
        res.status(500).json({ error: 'Server error: ' + err.message });
    }
});
exports.checkAvailability = checkAvailability;
const firebaseLogin = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { idToken, email, name, photoURL, uid } = req.body;
    if (!idToken) {
        return res.status(400).json({ error: 'ID token is required' });
    }
    try {
        // Verify the Firebase ID token
        const decodedToken = yield firebase_1.default.auth().verifyIdToken(idToken);
        // Check if UID from token matches the one sent in request
        if (decodedToken.uid !== uid) {
            return res.status(401).json({ error: 'Invalid token' });
        }
        // Check if user exists in our database
        const userResult = yield db_1.default.query('SELECT * FROM users WHERE firebase_uid = $1', [uid]);
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
                const usernameCheck = yield db_1.default.query('SELECT username FROM users WHERE username = $1', [username]);
                if (usernameCheck.rows.length === 0) {
                    usernameExists = false;
                }
                else {
                    username = `${baseUsername}${counter}`;
                    counter++;
                }
            }
            // Create the user
            const newUserResult = yield db_1.default.query(`INSERT INTO users (
          username, 
          email, 
          password, 
          firebase_uid, 
          profile_picture
        ) VALUES ($1, $2, $3, $4, $5) RETURNING *`, [
                username,
                email,
                // Generate a random password for these users since they won't use it
                yield bcryptjs_1.default.hash(Math.random().toString(36).slice(-10), 10),
                uid,
                photoURL || null
            ]);
            user = newUserResult.rows[0];
        }
        else {
            // User exists, update their information if needed
            yield db_1.default.query(`UPDATE users SET 
          email = $1, 
          profile_picture = $2
        WHERE firebase_uid = $3`, [email, photoURL || null, uid]);
        }
        // Generate our own JWT token
        const token = jsonwebtoken_1.default.sign({
            id: user.id,
            username: user.username,
            email: user.email,
            firebase_uid: user.firebase_uid
        }, JWT_SECRET, { expiresIn: '7d' });
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
    }
    catch (error) {
        console.error('Firebase authentication error:', error);
        res.status(401).json({ error: 'Invalid Firebase token: ' + error.message });
    }
});
exports.firebaseLogin = firebaseLogin;
