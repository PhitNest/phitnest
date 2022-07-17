const bcrypt = require('bcryptjs');
const jwt = require('../../../../utils/jwtHelper');
const { userModel } = require('../../../models/user');
const { validateRegister } = require('../validators');
const errorJson = require('../../../../utils/error');

module.exports = async (req, res) => {
    let errorObject = {}
    const { error } = validateRegister(req.body);
    if (error) {
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
            .json(errorJson(errorObject.msg, 'Error while registering.'));
    }

    let user = new userModel({
        email: req.body.email.trim(),
        password: await bcrypt.hash(req.body.password, 10),
        mobile: req.body.mobile.trim(),
        firstName: req.body.firstName.trim(),
        lastName: req.body.lastName.trim(),
        lastLogin: Date.now(),
    });

    user = await user.save().catch((err) => {
        return res
            .status(500).json(errorJson(err.message, 'An internal server error while registering.'))
    });

    const authorization = await jwt.signAccessToken(user._id);

    return res.status(200).send(authorization);
};