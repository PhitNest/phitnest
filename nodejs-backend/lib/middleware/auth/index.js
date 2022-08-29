const isAuthenticated = require('./isAuthenticated');
const validateLogin = require('./validateLogin');
const validateRegister = require('./validateRegister');

module.exports = {
  isAuthenticated: isAuthenticated,
  validateLogin: validateLogin,
  validateRegister: validateRegister,
};
