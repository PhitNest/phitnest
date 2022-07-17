const bcrypt = require('bcryptjs');
const jwt = require('../../../../utils/jwtHelper');
const { userModel } = require('../../../models/user');
const { validateLogin } = require('../validators');
const errorJson = require('../../../../utils/error');

module.exports = async (req, res) => {
    let errorObject = {}
    const { error } = validateLogin(req.body);
    if (error) {
        if (error.details[0].message.includes('email'))
            errorObject = { msg: 'Please provide a valid email.' };
        else if (error.details[0].message.includes('password'))
            errorObject = { msg: 'Please provide a valid password.' };
        else
            errorObject = { msg: 'Please provide all the required fields.' };

        return res
            .status(400)
            .json(errorJson(errorObject.msg, 'Error while trying to login.'));
    }
    const user = await userModel.findOne({ email: req.body.email.trim() })
        .select('+password')
        .catch((err) => {
            return res
                .status(500)
                .json(errorJson(err, 'An internal server error occurred, please try again.'));
        });
    if (!user)
        return res
            .status(404)
            .json(errorJson('404 Error', 'An account with this email address was not found.'));

    const match = await bcrypt.compare(req.body.password, user.password);
    if (!match)
        return res
            .status(400)
            .json(errorJson('400 error', 'You have entered an invalid email or password.'));


    const authorization = await jwt.signAccessToken(user._id);

    await userModel.updateOne(
        { email: req.body.email.trim() },
        {
            $set: { lastLogin: Date.now() },
        }).catch((err) => {
            return res
                .status(500)
                .json(
                    errorJson(
                        err,
                        'An internal server error occurred.')
                );
        });

    return res.status(200).send(authorization);
};