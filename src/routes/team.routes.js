"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const teams_controller_1 = require("../controllers/teams.controller");
const auth_middleware_1 = require("../middlewares/auth.middleware");
const router = express_1.default.Router();
router.post('/create', auth_middleware_1.verifyToken, teams_controller_1.createTeam);
router.post('/join', auth_middleware_1.verifyToken, teams_controller_1.joinTeam);
router.post('/leave', auth_middleware_1.verifyToken, teams_controller_1.leaveTeam);
router.get('/teamInfo', auth_middleware_1.verifyToken, teams_controller_1.getTeamInfo);
router.get('/current', auth_middleware_1.verifyToken, teams_controller_1.getCurrentTeam);
router.post('/promote', auth_middleware_1.verifyToken, teams_controller_1.promoteToAdmin);
router.post('/demote', auth_middleware_1.verifyToken, teams_controller_1.demoteAdmin);
exports.default = router;
