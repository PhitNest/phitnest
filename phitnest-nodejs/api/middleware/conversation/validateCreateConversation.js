const { userModel } = require('../../models/user');

module.exports = async (req, res, next) => {
    try {
        if (req.body.otherUser != res.locals.uid) {
            const otherUser = await userModel.findById(req.body.otherUser);
            if (otherUser) {
                return next();
            }
        }
    } catch (error) { }
    return res.status(500).send('The query contained an invalid user id.');
};