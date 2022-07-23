const joi = require('joi');

const minMessageLength = 1;
const maxMessageLength = 64;
module.exports = {
    messageValidator: joi.string().trim().min(minMessageLength).max(maxMessageLength).required(),
}