const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth');
const duplicateEmail = require('../middleware/auth/checkEmail');
const duplicateMobile = require('../middleware/auth/checkMobile');
const invalidLoginRequest = require('../middleware/auth/validateLogin');
const invalidRegisterRequest = require('../middleware/auth/validateRegister');

router.post('/register', [invalidRegisterRequest, duplicateEmail, duplicateMobile], authController.register);
router.post('/login', [invalidLoginRequest], authController.login);
module.exports = router;