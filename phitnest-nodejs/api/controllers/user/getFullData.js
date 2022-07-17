const { userModel } = require('../../models/user');
const errorJson = require('../../../utils/error');

module.exports = async (req, res) => {
    let user = await userModel.findById(res.locals.jwtData._id).catch((e) => {
        return res.status(500).json(errorJson(e, 'An error occurred while getting your information, please try again.'))
    });

    res.status(200).send([{
        email: user.email,
        mobile: user.mobile,
        firstName: user.firstName,
        lastName: user.lastName,
        bio: user.bio,
        friends: user.friends,
        conversations: user.conversations,
        online: user.online,
    }]);
}