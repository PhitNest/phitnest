const joi = require('joi');
joi.objectId = require('joi-objectid')(joi);

const minEmailLength = 3;
const maxEmailLength = 30;
const emailValidator = joi.string().trim().email().min(minEmailLength).max(maxEmailLength).required();

const minPasswordLength = 6;
const maxPasswordLength = 20;
const passwordValidator = joi.string().min(minPasswordLength).max(maxPasswordLength).required();

const mobileRegex = /(^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$)/;
const minPhoneNumberLength = 1;
const maxPhoneNumberLength = 16;
const mobileValidator = joi.string().trim().pattern(mobileRegex).min(minPhoneNumberLength).max(maxPhoneNumberLength).required();

const minFirstNameLength = 2;
const maxFirstNameLength = 16;
const firstNameValidator = joi.string().trim().min(minFirstNameLength).max(maxFirstNameLength).required();

const minLastNameLength = 0;
const maxLastNameLength = 16;
const lastNameValidator = joi.string().trim().min(minLastNameLength).max(maxLastNameLength).required();

const minBioLength = 0;
const maxBioLength = 64;
const bioValidator = joi.string().trim().min(minBioLength).max(maxBioLength).required();

const onlineValidator = joi.bool().required();

function validateRegister(req) {
    const schema = joi.object({
        email: emailValidator,
        password: passwordValidator,
        mobile: mobileValidator,
        firstName: firstNameValidator,
        lastName: lastNameValidator.optional(),
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

function validateUpdatePublicData(req) {
    const schema = joi.object({
        firstName: firstNameValidator.optional(),
        lastName: lastNameValidator.optional(),
        bio: bioValidator.optional(),
        online: onlineValidator.optional(),
    });
    return schema.validate(req);
}

module.exports = {
    validateRegister: validateRegister,
    validateLogin: validateLogin,
    validateUpdatePublicData: validateUpdatePublicData,
}