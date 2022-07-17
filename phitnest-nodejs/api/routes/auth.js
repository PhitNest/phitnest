const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth');
const { checkEmail, checkMobile, validateLogin, validateRegister } = require('../middleware/auth');

router.post('/register', [validateRegister, checkEmail, checkMobile], authController.register);
router.post('/login', [validateLogin], authController.login);
module.exports = router;