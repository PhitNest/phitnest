const model = require('./userModel');
const validate = require('./userValidate');

module.exports = {
    userModel: model.userModel,
    userSchema: model.userSchema,
    userValidate: validate,
};