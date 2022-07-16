const bcrypt = require("bcryptjs");
const { userModel, userValidate } = require("../../../models/user");
const errorJson = require("../../../../utils/error");

let errorObject = {}
module.exports = async (req, res) => {
    const { error } = userValidate.register(req.body);
    if (error) {
        if (error.details[0].message.includes("email"))
            errorObject = { msg: "Please provide a valid email!" };
        else if (error.details[0].message.includes("password"))
            errorObject = { msg: `Please provide a password that longer than ${userValidate.minPasswordLength} letters and shorter than ${userValidate.maxPasswordLength} letters.`, };
        else
            errorObject = { msg: "Please provide all the required fields!" };

        return res
            .status(400)
            .json(errorJson(errorObject.msg, "Error while registering!"));
    }

    let user = new userModel({
        email: req.body.email.trim(),
        password: await bcrypt.hash(req.body.password, 10),
        lastLogin: Date.now(),
    });

    user = await user.save().catch((err) => {
        return res
            .status(500).json(errorJson(err.message, "An interval server error while registering you."))
    });

    const authorization = await jwt.signAccessToken(user._id);

    return res.status(200).send(authorization);
};