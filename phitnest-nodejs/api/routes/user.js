const express = require('express');
const router = express.Router();
const userController = require('../controllers/user');
const { validateUpdatePublicData } = require('../middleware/user');

router.patch('/publicData', [validateUpdatePublicData], userController.updatePublicData);
router.get('/publicData', userController.getPublicData);
router.get('/fullData', userController.getFullData);
module.exports = router;