const joi = require('joi');

const minEmailLength = 3;
const maxEmailLength = 30;
const minPasswordLength = 6;
const maxPasswordLength = 20;
const mobileRegex = /(^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$)/;
const minPhoneNumberLength = 1;
const maxPhoneNumberLength = 16;
const minFirstNameLength = 2;
const maxFirstNameLength = 16;
const minLastNameLength = 0;
const maxLastNameLength = 16;
const minBioLength = 0;
const maxBioLength = 64;

module.exports = {
    emailValidator: joi.string().trim().email().min(minEmailLength).max(maxEmailLength).required(),
    passwordValidator: joi.string().min(minPasswordLength).max(maxPasswordLength).required(),
    mobileValidator: joi.string().trim().pattern(mobileRegex).min(minPhoneNumberLength).max(maxPhoneNumberLength).required(),
    firstNameValidator: joi.string().trim().min(minFirstNameLength).max(maxFirstNameLength).required(),
    lastNameValidator: joi.string().trim().min(minLastNameLength).max(maxLastNameLength).required(),
    bioValidator: joi.string().trim().min(minBioLength).max(maxBioLength).required(),
    onlineValidator: joi.bool().required(),
}