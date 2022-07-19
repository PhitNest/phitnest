const { userModel } = require('../../models/user');
const errorJson = require('../../../utils/error');

module.exports = async (req, res) => {
    try {
        const user = await userModel.findById(res.locals.uid)
        if (user) {
            res.status(200).json({
                email: user.email,
                mobile: user.mobile,
                firstName: user.firstName,
                lastName: user.lastName,
                bio: user.bio,
                online: user.online,
            });
        }
    } catch (e) { }
    return res.status(500).json(errorJson(e, 'An error occurred while getting your information, please try again.'))
}