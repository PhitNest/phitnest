const errorJson = require('../../../utils/error');
const { userModel } = require('../../models/user');

module.exports = async (req, res, next) => {
    let hasMobile = null;
    try {
        hasMobile = await userModel.findOne({ mobile: req.body.mobile })
    } catch (err) {
        return res
            .status(500)
            .json(errorJson(err.message, 'An internal server error while finding user with mobile.'))
    };

    if (hasMobile) {
        return res
            .status(409)
            .json(errorJson('Duplicate Mobile Number', 'An account with this mobile number already exists.'));
    }

    next();
};