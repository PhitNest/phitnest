const isAuthenticated = require('./isAuthenticated');
const validateLogin = require('./validateLogin');
const validateRegister = require('./validateRegister');
const userExists = require('./userExists');

module.exports = {
  isAuthenticated: isAuthenticated,
  validateLogin: validateLogin,
  validateRegister: validateRegister,
  userExists: userExists,
};
