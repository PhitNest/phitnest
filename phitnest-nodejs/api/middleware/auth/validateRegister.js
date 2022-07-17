const errorJson = require('../../../utils/error');
const { validateRegister } = require('../validators');

module.exports = async (req, res, next) => {
    const { error } = validateRegister(req.body);
    if (error) {
        let errorMessage = '';
        if (error.details[0].message.includes('email')) {
            errorMessage = 'Please provide a valid email.';
        }
        else if (error.details[0].message.includes('password')) {
            errorMessage = 'Please provide a valid password.';
        }
        else if (error.details[0].message.includes('mobile')) {
            errorMessage = 'Please provide a valid phone number.';
        }
        else if (error.details[0].message.includes('firstName')) {
            errorMessage = 'Please provide a valid first name.';
        }
        else if (error.details[0].message.includes('lastName')) {
            errorMessage = 'Please provide a valid last name.';
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