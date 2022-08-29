const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth');
const { validateLogin, validateRegister } = require('../middleware/auth');

router.post('/register', [validateRegister], authController.register);
router.post('/login', [validateLogin], authController.login);
module.exports = router;
