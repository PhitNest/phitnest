const bcrypt = require('bcryptjs');
const jwt = require('../../../utils/jwtHelper');
const { userModel } = require('../../models/user');
const errorJson = require('../../../utils/error');

module.exports = async (req, res) => {
    let user = null;
    try {
        user = await userModel.findOne({ email: req.body.email.trim() })
            .select('+password');
    } catch (error) {
        return res
            .status(500)
            .json(errorJson(err, 'An internal server error occurred, please try again.'));
    }

    if (!user) {
        return res
            .status(404)
            .json(errorJson('Error', 'An account with this email address was not found.'));
    }

    const match = await bcrypt.compare(req.body.password, user.password);
    if (!match) {
        return res
            .status(400)
            .json(errorJson('Error', 'You have entered an invalid email or password.'));
    }

    const authorization = await jwt.signAccessToken(user._id);

    try {
        await userModel.findById(user._id).updateOne({ lastSeen: Date.now() });
    } catch (error) {
        return res
            .status(500)
            .json(
                errorJson(
                    err,
                    'An internal server error occurred.')
            );
    };

    return res.status(200).send(authorization);
};