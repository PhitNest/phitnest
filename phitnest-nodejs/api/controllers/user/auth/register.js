const bcrypt = require('bcryptjs');
const jwt = require('../../../../utils/jwtHelper');
const { userModel, userValidate } = require('../../../ models / user');
const errorJson = require('../../../../utils/error');

let errorObject = {}
module.exports = async (req, res) => {
    const { error } = userValidate.register(req.body);
    if (error) {
        if (error.details[0].message.includes('email'))
            errorObject = { msg: 'Please provide a valid email.' };
        else if (error.details[0].message.includes('password'))
            errorObject = { msg: `Please provide a password that is longer than ${userValidate.minPasswordLength} letters and shorter than ${userValidate.maxPasswordLength} letters.`, };
        else if (error.details[0].message.includes('mobile'))
            errorObject = { msg: 'Please provide a valid phone number.', };
        else if (error.details[0].message.includes('firstName'))
            errorObject = { msg: `Please provide a first name that is longer than ${userValidate.minPasswordLength} letters and shorter than ${userValidate.maxPasswordLength} letters.` };
        else if (error.details[0].message.includes('lastName'))
            errorObject = { msg: `Your last name can be a max of ${userValidate.maxLastNameLength} letters.` };
        else
            errorObject = { msg: 'Please provide all the required fields!' };
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
        bio: '',
        lastLogin: Date.now(),
    });

    user = await user.save().catch((err) => {
        return res
            .status(500).json(errorJson(err.message, 'An interval server error while registering you.'))
    });

    const authorization = await jwt.signAccessToken(user._id);

    return res.status(200).send(authorization);
};