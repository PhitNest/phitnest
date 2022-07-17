const JWT = require('jsonwebtoken');
const { userModel } = require('../../models/user');
const { validateUpdatePublicData } = require('./validators');
const errorJson = require('../../../utils/error');

module.exports = async (req, res) => {
    var str = req.get('authorization');
    try {
        let data = JWT.verify(str, process.env.JWT_SECRET);

        let errorObject = {}
        const { error } = validateUpdatePublicData(req.body);
        if (error) {
            if (error.details[0].message.includes('firstName'))
                errorObject = { msg: 'Please provide a valid first name.' };
            else if (error.details[0].message.includes('lastName'))
                errorObject = { msg: 'Please provide a valid last name.' };
            else if (error.details[0].message.includes('bio'))
                errorObject = { msg: 'Please provide a valid bio.' };
            else if (error.details[0].message.includes('online'))
                errorObject = { msg: 'Please provide a valid online status.' };
            else
                errorObject = { msg: 'Invalid Request' };
            return res
                .status(400)
                .json(errorJson(errorObject.msg, 'Error while updating user.'));
        }

        try {
            await userModel.findById(data._id).updateOne(req.body);
        } catch (error) {
            return res
                .status(500)
                .json(
                    errorJson(
                        err,
                        'An internal server error occurred.')
                );
        }

        res.status(200).send('Success');
    } catch (err) {
        res.status(401).send('Bad Token');
    }
};