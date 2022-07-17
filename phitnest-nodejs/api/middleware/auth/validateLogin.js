const errorJson = require('../../../utils/error');
const { validateLogin } = require('../validators');

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
            .json(errorJson('Invalid Request', errorMessage));
    }

    next();
};