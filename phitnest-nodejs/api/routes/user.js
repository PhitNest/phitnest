const express = require('express');
const router = express.Router();
const userController = require('../controllers/user');
const duplicateEmail = require('../middleware/auth/checkEmail');
const duplicateMobile = require('../middleware/auth/checkMobile');

router.post('/register', [duplicateEmail, duplicateMobile], userController.register);
router.post('/login', userController.login);
router.get('/fullData', userController.getFullData);
router.get('/publicData', userController.getPublicData);
module.exports = router;