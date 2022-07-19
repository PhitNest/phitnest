const { userModel } = require('../../models/user');
const errorJson = require('../../../utils/error');

module.exports = async (req, res, next) => {
    try {
        if (req.body.otherUser != res.locals.uid) {
            const otherUser = await userModel.findById(req.body.otherUser);
            if (otherUser) {
                return next();
            }
        }
    } catch (error) { }
    return res.status(500).json(errorJson('Invalid ID', 'The query contained an invalid user id.'));
};