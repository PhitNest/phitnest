const { firstNameValidator, lastNameValidator, bioValidator, onlineValidator } = require('../validators');
const joi = require('joi');

function validateUpdatePublicData(req) {
    const schema = joi.object({
        firstName: firstNameValidator.optional(),
        lastName: lastNameValidator.optional(),
        bio: bioValidator.optional(),
        online: onlineValidator.optional(),
    });
    return schema.validate(req);
}

module.exports = async (req, res, next) => {
    const { error } = validateUpdatePublicData(req.body);
    if (error) {
        let errorMessage = '';
        if (error.details[0].message.includes('firstName'))
            errorMessage = 'Please provide a valid first name.';
        else if (error.details[0].message.includes('lastName'))
            errorMessage = 'Please provide a valid last name.';
        else if (error.details[0].message.includes('bio'))
            errorMessage = 'Please provide a valid bio.';
        else if (error.details[0].message.includes('online'))
            errorMessage = 'Please provide a valid online status.';
        else
            errorMessage = 'Please do not provide extra fields.';
        return res
            .status(400)
            .send(errorMessage);
    }

    next();
};