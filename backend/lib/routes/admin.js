const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin');
const {
  validateLogin,
  validateRegister,
  isAdminAuthenticated,
} = require('../middleware/auth');

router.post(
  '/register',
  [isAdminAuthenticated, validateRegister],
  adminController.register
);
router.post('/login', [validateLogin], adminController.login);
module.exports = router;
