const { emailValidator, passwordValidator } = require('../validators');
const joi = require('joi');

function validateLogin(req) {
    const schema = joi.object({
        email: emailValidator,
        password: passwordValidator,
    });
    return schema.validate(req);
}

module.exports = async (req, res, next) => {
    const { error } = validateLogin(req.body);
    if (error) {
        let errorMessage = '';
        if (error.details[0].message.includes('email')) {
            errorMessage = 'Please provide a valid email.';
        }
        else if (error.details[0].message.includes('password')) {
            errorMessage = 'Please provide a valid password.';
        }
        else {
            errorMessage = 'Please provide the required fields.';
        }

        return res
            .status(400)
            .send(errorMessage);
    }

    next();
};