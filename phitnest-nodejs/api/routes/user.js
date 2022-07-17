const express = require('express');
const router = express.Router();
const userController = require('../controllers/user');
const { isAuthenticated } = require('../middleware/auth');
const { validateUpdatePublicData } = require('../middleware/user');

router.patch('/publicData', [isAuthenticated, validateUpdatePublicData], userController.updatePublicData);
router.get('/publicData', [isAuthenticated], userController.getPublicData);
router.get('/fullData', [isAuthenticated], userController.getFullData);
module.exports = router;