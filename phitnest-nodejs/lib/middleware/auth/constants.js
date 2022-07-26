module.exports = {
    minEmailLength: 3,
    maxEmailLength: 30,
    minPasswordLength: 6,
    maxPasswordLength: 20,
    mobileRegex: /(^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$)/,
    minPhoneNumberLength: 1,
    maxPhoneNumberLength: 16,
    minFirstNameLength: 2,
    maxFirstNameLength: 16,
    minLastNameLength: 0,
    maxLastNameLength: 16,
    minAge: 13,
}