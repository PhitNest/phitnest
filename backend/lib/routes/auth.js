const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth');
const admin = require('./admin');
const { validateLogin, validateRegister } = require('../middleware/auth');

router.use('/admin', admin);

router.post('/register', [validateRegister], authController.register);
router.post('/login', [validateLogin], authController.login);
module.exports = router;
