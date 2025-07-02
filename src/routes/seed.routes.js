"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const multer_1 = __importDefault(require("multer"));
const seedLearning_controller_1 = require("../controllers/seedLearning.controller");
const router = express_1.default.Router();
const upload = (0, multer_1.default)();
router.post('/seed-learning', upload.single('zip'), seedLearning_controller_1.seedLearningMaterials);
router.delete('/seed-learning', seedLearning_controller_1.deleteAllLearningMaterials);
exports.default = router;
