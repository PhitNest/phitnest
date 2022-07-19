const { userModel } = require('../../models/user');
const errorJson = require('../../../utils/error');

module.exports = async (req, res) => {
    try {
        const user = await userModel.findById(req.query.id);
        if (user) {
            res.status(200).json({
                firstName: user.firstName,
                lastName: user.lastName,
                bio: user.bio,
                online: user.online,
            });
        }
    } catch (error) { }

    return res.status(500).json(errorJson('Invalid ID', 'The query contained an invalid user id.'));
}