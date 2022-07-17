const register = require('./auth/register');
const login = require('./auth/login');
const getFullData = require('./getFullData');
const getPublicData = require('./getPublicData');
module.exports = {
    register: register,
    login: login,
    getFullData: getFullData,
    getPublicData: getPublicData,
}