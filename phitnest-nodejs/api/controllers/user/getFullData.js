const { userModel } = require('../../models/user');

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
    return res.status(500).send('An error occurred while getting your information, please try again.');
}