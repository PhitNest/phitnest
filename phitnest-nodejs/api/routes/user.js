const express = require('express');
const router = express.Router();
const userController = require('../controllers/user');
const duplicateEmail = require('../middleware/auth/checkEmail');
const duplicateMobile = require('../middleware/auth/checkMobile');

router.post('/register', [duplicateEmail, duplicateMobile], userController.register);
router.post('/login', userController.login);
router.get('/data', userController.getUser);
module.exports = router;