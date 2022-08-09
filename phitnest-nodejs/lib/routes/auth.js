const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth');
const {
  validateLogin,
  validateRegister,
  userExists,
} = require('../middleware/auth');

router.post(
  '/register',
  [validateRegister, userExists],
  authController.register
);
router.post('/login', [validateLogin], authController.login);
module.exports = router;
