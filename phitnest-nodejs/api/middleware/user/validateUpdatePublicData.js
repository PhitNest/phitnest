const errorJson = require('../../../utils/error');
const { validateUpdatePublicData } = require('../validators');

module.exports = async (req, res, next) => {
    const { error } = validateUpdatePublicData(req.body);
    if (error) {
        let errorObject = {}
        if (error.details[0].message.includes('firstName'))
            errorObject = { msg: 'Please provide a valid first name.' };
        else if (error.details[0].message.includes('lastName'))
            errorObject = { msg: 'Please provide a valid last name.' };
        else if (error.details[0].message.includes('bio'))
            errorObject = { msg: 'Please provide a valid bio.' };
        else if (error.details[0].message.includes('online'))
            errorObject = { msg: 'Please provide a valid online status.' };
        else
            errorObject = { msg: 'Please do not provide extra fields.' };
        return res
            .status(400)
            .json(errorJson('Invalid Request', errorObject.msg));
    }

    next();
};