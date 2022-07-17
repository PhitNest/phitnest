const bcrypt = require('bcryptjs');
const jwt = require('../../../utils/jwtHelper');
const { userModel } = require('../../models/user');
const errorJson = require('../../../utils/error');

module.exports = async (req, res) => {
    let user = new userModel({
        email: req.body.email.trim(),
        password: await bcrypt.hash(req.body.password, 10),
        mobile: req.body.mobile.trim(),
        firstName: req.body.firstName.trim(),
        lastLogin: Date.now(),
    });

    if (req.body.lastName != undefined) {
        user.lastName = req.body.lastName.trim();
    }

    try {
        user = await user.save()
    } catch (error) {
        return res
            .status(500).json(errorJson(err.message, 'An internal server error while registering.'))
    }

    const authorization = await jwt.signAccessToken(user._id);

    return res.status(200).send(authorization);
};