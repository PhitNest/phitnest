const errorJson = require('../../../utils/error');
const { validateLogin } = require('../validators');

module.exports = async (req, res, next) => {
    const { error } = validateLogin(req.body);
    if (error) {
        let errorObject = {}
        if (error.details[0].message.includes('email'))
            errorObject = { msg: 'Please provide a valid email.' };
        else if (error.details[0].message.includes('password'))
            errorObject = { msg: 'Please provide a valid password.' };
        else
            errorObject = { msg: 'Please provide all the required fields.' };

        return res
            .status(400)
            .json(errorJson('Invalid Request', errorObject.msg));
    }

    next();
};