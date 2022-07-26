const { minPasswordLength, maxPasswordLength, minEmailLength, maxEmailLength } = require('./constants');
const joi = require('joi');

function validateLogin(req) {
    const schema = joi.object({
        email: joi.string().trim().email().min(minEmailLength).max(maxEmailLength).required(),
        password: joi.string().min(minPasswordLength).max(maxPasswordLength).required(),
    });
    return schema.validate(req);
}

module.exports = async (req, res, next) => {
    const { error } = validateLogin(req.body);
    if (error) {
        return res
            .status(400)
            .send(error.details[0].message);
    }
    next();
};