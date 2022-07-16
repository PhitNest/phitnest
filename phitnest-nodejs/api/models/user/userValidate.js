const joi = require('joi');
joi.objectId = require('joi-objectid')(joi);

const minPasswordLength = 6;
const maxPasswordLength = 20;
const minEmailLength = 3;
const maxEmailLength = 30;

const emailValidator = joi.string().trim().email().min(minEmailLength).max(maxEmailLength).required();
const passwordValidator = joi.string().min(minPasswordLength).max(maxPasswordLength).required();

function validateRegister(user) {
    const schema = joi.object({
        email: emailValidator,
        password: passwordValidator,
    })
    return schema.validate(user);
}

function validateUserLogin(user) {
    const schema = joi.object({
        email: emailValidator,
        password: passwordValidator,
    });
    return schema.validate(user);
}

module.exports = {
    validateRegister: validateRegister,
    validateUserLogin: validateUserLogin,
}