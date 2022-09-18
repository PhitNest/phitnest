const isAuthenticated = require('./isAuthenticated');
const validateLogin = require('./validateLogin');
const isAdminAuthenticated = require('./isAdminAuthenticated');
const validateRegister = require('./validateRegister');

module.exports = {
  isAuthenticated: isAuthenticated,
  isAdminAuthenticated: isAdminAuthenticated,
  validateLogin: validateLogin,
  validateRegister: validateRegister,
};
