const joi = require('joi');
joi.objectId = require('joi-objectid')(joi);

const minPasswordLength = 6;
const maxPasswordLength = 20;

const minEmailLength = 3;
const maxEmailLength = 30;

const minPhoneNumberLength = 1;
const maxPhoneNumberLength = 16;

const minFirstNameLength = 2;
const maxFirstNameLength = 16;

const minLastNameLength = 0;
const maxLastNameLength = 16;

const emailValidator = joi.string().trim().email().min(minEmailLength).max(maxEmailLength).required();
const passwordValidator = joi.string().min(minPasswordLength).max(maxPasswordLength).required();
const mobileValidator = joi.string().trim().min(minPhoneNumberLength).max(maxPhoneNumberLength).required();
const firstNameValidator = joi.string().trim().min(minFirstNameLength).max(maxFirstNameLength).required();
const lastNameValidator = joi.string().trim().min(minLastNameLength).max(maxLastNameLength).required();

function validateRegister(req) {
    const schema = joi.object({
        email: emailValidator,
        password: passwordValidator,
        mobile: mobileValidator,
        firstName: firstNameValidator,
        lastName: lastNameValidator,
    })
    return schema.validate(req);
}

function validateLogin(req) {
    const schema = joi.object({
        email: emailValidator,
        password: passwordValidator,
    });
    return schema.validate(req);
}

module.exports = {
    validateRegister: validateRegister,
    validateLogin: validateLogin,
}