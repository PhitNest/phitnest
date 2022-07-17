const errorJson = require('../../../utils/error');
const { validateRegister } = require('../validators');

module.exports = async (req, res, next) => {
    const { error } = validateRegister(req.body);
    if (error) {
        let errorObject = {}
        if (error.details[0].message.includes('email'))
            errorObject = { msg: 'Please provide a valid email.' };
        else if (error.details[0].message.includes('password'))
            errorObject = { msg: 'Please provide a valid password.', };
        else if (error.details[0].message.includes('mobile'))
            errorObject = { msg: 'Please provide a valid phone number.', };
        else if (error.details[0].message.includes('firstName'))
            errorObject = { msg: 'Please provide a valid first name.' };
        else if (error.details[0].message.includes('lastName'))
            errorObject = { msg: 'Please provide a valid last name.' };
        else
            errorObject = { msg: 'Please provide all the required fields.' };
        return res
            .status(400)
            .json(errorJson('Invalid Request', errorObject.msg));
    }

    next();
};