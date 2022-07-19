const { userModel } = require('../../models/user');

module.exports = async (req, res, next) => {
    let hasEmail = null;
    try {
        hasEmail = await userModel.findOne({ email: req.body.email })
    } catch (err) {
        return res
            .status(500)
            .send('An internal server error while finding user with email.');
    };

    if (hasEmail) {
        return res
            .status(409)
            .send('An account with this email address already exists.');
    }

    next();
};