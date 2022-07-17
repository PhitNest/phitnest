const checkEmail = require('./checkEmail');
const checkMobile = require('./checkMobile');
const isAuthenticated = require('./isAuthenticated');
const validateLogin = require('./validateLogin');
const validateRegister = require('./validateRegister');

module.exports = {
    checkEmail: checkEmail,
    checkMobile: checkMobile,
    isAuthenticated: isAuthenticated,
    validateLogin: validateLogin,
    validateRegister: validateRegister,
}