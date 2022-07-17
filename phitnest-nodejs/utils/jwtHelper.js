const JWT = require('jsonwebtoken');
require('dotenv').config();

module.exports = {
    signAccessToken: async (userId) => {
        const authorization = JWT.sign({ _id: userId }, process.env.JWT_SECRET, { expiresIn: '2h' });
        return authorization;
    }
}