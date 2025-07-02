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
exports.demoteAdmin = exports.getCurrentTeam = exports.deleteTeam = exports.promoteToAdmin = exports.leaveTeam = exports.getTeamInfo = exports.joinTeam = exports.createTeam = void 0;
const db_1 = __importDefault(require("../config/db"));
const generate_team_code_1 = require("../utils/generate-team-code");
const createTeam = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const userId = req.user.id;
    const { name } = req.body;
    try {
        const existing = yield db_1.default.query("SELECT * FROM team_members WHERE user_id = $1", [userId]);
        if (existing.rowCount && existing.rowCount > 0) {
            return res.status(400).json({ error: 'User already in a team' });
        }
        let joinCode;
        while (true) {
            joinCode = (0, generate_team_code_1.generateTeamCode)();
            const result = yield db_1.default.query('SELECT id FROM teams WHERE join_code = $1', [joinCode]);
            if (result.rowCount == 0) {
                break;
            }
        }
        const teamRes = yield db_1.default.query('INSERT INTO teams (name, join_code, created_by) VALUES ($1, $2, $3) RETURNING id', [name, joinCode, userId]);
        const teamId = teamRes.rows[0].id;
        yield db_1.default.query('INSERT INTO team_members (user_id, team_id, is_admin) VALUES ($1, $2, $3)', [userId, teamId, true]);
        res.status(201).json({ teamId, joinCode });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: "Server encountered an error" });
    }
});
exports.createTeam = createTeam;
const joinTeam = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const userId = req.user.id;
    const { joinCode } = req.body;
    try {
        const existing = yield db_1.default.query('SELECT * FROM team_members WHERE user_id = $1', [userId]);
        if (existing.rowCount && existing.rowCount > 0) {
            return res.status(400).json({ error: 'User already in a team' });
        }
        const teamRes = yield db_1.default.query('SELECT id FROM teams WHERE join_code = $1', [joinCode]);
        if (teamRes.rowCount === 0) {
            return res.status(404).json({ error: 'Team not found' });
        }
        yield db_1.default.query('INSERT INTO team_members (user_id, team_id, is_admin) VALUES ($1, $2, false)', [userId, teamRes.rows[0].id]);
        res.json({ message: 'Joined team' });
    }
    catch (err) {
        res.status(500).json({ error: 'Server error' });
    }
});
exports.joinTeam = joinTeam;
const getTeamInfo = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const userId = req.user.id;
    try {
        const teamRes = yield db_1.default.query(`
          SELECT t.id, t.name, t.join_code, t.created_at
          FROM teams t
          JOIN team_members tm ON tm.team_id = t.id
          WHERE tm.user_id = $1
        `, [userId]);
        if (teamRes.rowCount === 0) {
            return res.status(404).json({ error: 'User not in a team' });
        }
        const team = teamRes.rows[0];
        const membersRes = yield db_1.default.query(`
          SELECT u.username, u.email, u.profile_picture, tm.is_admin
          FROM users u
          JOIN team_members tm ON tm.user_id = u.id
          WHERE tm.team_id = $1
        `, [team.id]);
        res.json(Object.assign(Object.assign({}, team), { members: membersRes.rows }));
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error while fetching team info' });
    }
});
exports.getTeamInfo = getTeamInfo;
const leaveTeam = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const userId = req.user.id;
    try {
        const result = yield db_1.default.query('SELECT is_admin FROM team_members WHERE user_id = $1', [userId]);
        if (result.rowCount === 0) {
            return res.status(404).json({ error: 'User not in a team' });
        }
        const isAdmin = result.rows[0].is_admin;
        if (isAdmin) {
            return res.status(403).json({ error: 'Admins cannot leave the team. You can delete the team instead.' });
        }
        yield db_1.default.query('DELETE FROM team_members WHERE user_id = $1', [userId]);
        res.json({ message: 'Left the team successfully' });
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error while leaving team' });
    }
});
exports.leaveTeam = leaveTeam;
const promoteToAdmin = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    const adminId = req.user.id;
    const { targetUserEmail } = req.body;
    try {
        const adminCheck = yield db_1.default.query(`
            SELECT team_id, is_admin FROM team_members WHERE user_id = $1
        `, [adminId]);
        if (adminCheck.rowCount === 0 || !((_a = adminCheck.rows[0]) === null || _a === void 0 ? void 0 : _a.is_admin)) {
            return res.status(403).json({ error: "Only admins can promote others" });
        }
        const teamId = adminCheck.rows[0].team_id;
        const userQuery = yield db_1.default.query(`
            SELECT id FROM users WHERE email = $1
        `, [targetUserEmail]);
        if (userQuery.rowCount === 0) {
            return res.status(404).json({ error: "User with this email not found" });
        }
        const targetUserId = userQuery.rows[0].id;
        const teamCheck = yield db_1.default.query(`
            SELECT * FROM team_members WHERE user_id = $1 AND team_id = $2
        `, [targetUserId, teamId]);
        if (teamCheck.rowCount === 0) {
            return res.status(400).json({ error: "Target user is not in your team" });
        }
        if (teamCheck.rows[0].is_admin) {
            return res.status(400).json({ error: "User is already an admin" });
        }
        yield db_1.default.query(`
            UPDATE team_members SET is_admin = true WHERE user_id = $1 AND team_id = $2
        `, [targetUserId, teamId]);
        res.json({
            message: "User promoted to admin successfully",
            user: targetUserEmail
        });
    }
    catch (err) {
        console.error("Error promoting user to admin:", err);
        res.status(500).json({ error: "Server error while promoting user" });
    }
});
exports.promoteToAdmin = promoteToAdmin;
const deleteTeam = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const adminId = req.user.id;
    // Get team and check admin status
    const res1 = yield db_1.default.query(`
    SELECT t.id FROM teams t
    JOIN team_members tm ON tm.team_id = t.id
    WHERE tm.user_id = $1 AND tm.is_admin = true
  `, [adminId]);
    if (res1.rowCount === 0) {
        return res.status(403).json({ error: "Only admins can delete the team" });
    }
    const teamId = res1.rows[0].id;
    // Delete team
    yield db_1.default.query('DELETE FROM teams WHERE id = $1', [teamId]);
    res.json({ message: "Team deleted and all members removed" });
});
exports.deleteTeam = deleteTeam;
const getCurrentTeam = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const userId = req.user.id;
    try {
        const teamRes = yield db_1.default.query(`
      SELECT t.id, t.name, t.join_code, t.created_at
      FROM teams t
      JOIN team_members tm ON t.id = tm.team_id
      WHERE tm.user_id = $1
    `, [userId]);
        if (teamRes.rowCount === 0) {
            return res.status(404).json({ error: "User is not in a team" });
        }
        const team = teamRes.rows[0];
        const membersRes = yield db_1.default.query(`
      SELECT u.username, u.email, u.profile_picture, tm.is_admin
      FROM users u
      JOIN team_members tm ON u.id = tm.user_id
      WHERE tm.team_id = $1
    `, [team.id]);
        res.json(Object.assign(Object.assign({}, team), { members: membersRes.rows }));
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error while fetching team info" });
    }
});
exports.getCurrentTeam = getCurrentTeam;
const demoteAdmin = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const adminId = req.user.id;
    const { targetUserEmail } = req.body;
    try {
        const adminRes = yield db_1.default.query(`
      SELECT team_id, is_admin FROM team_members WHERE user_id = $1
    `, [adminId]);
        if (adminRes.rowCount === 0 || !adminRes.rows[0].is_admin) {
            return res.status(403).json({ error: "Only admins can perform this action" });
        }
        const teamId = adminRes.rows[0].team_id;
        const targetUserRes = yield db_1.default.query(`
      SELECT id FROM users WHERE email = $1
    `, [targetUserEmail]);
        if (targetUserRes.rowCount === 0) {
            return res.status(404).json({ error: "Target user not found" });
        }
        const targetUserId = targetUserRes.rows[0].id;
        if (targetUserId === adminId) {
            return res.status(400).json({ error: "You cannot demote yourself" });
        }
        const teamMemberRes = yield db_1.default.query(`
      SELECT * FROM team_members WHERE user_id = $1 AND team_id = $2
    `, [targetUserId, teamId]);
        if (teamMemberRes.rowCount === 0) {
            return res.status(400).json({ error: "User is not in your team" });
        }
        yield db_1.default.query(`
      UPDATE team_members SET is_admin = false WHERE user_id = $1
    `, [targetUserId]);
        res.json({ message: "User demoted from admin successfully" });
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error while demoting admin" });
    }
});
exports.demoteAdmin = demoteAdmin;
