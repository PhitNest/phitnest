const { conversationModel } = require('../../models/conversation');
const errorJson = require('../../../utils/error');

module.exports = async (req, res, next) => {
    try {
        const conversation = await conversationModel.findOne({
            "participants": { "$size": 2, "$all": [req.body.otherUser, res.locals.uid] }
        });
        if (!conversation) {
            return next();
        } else {
            return res.status(200).json({
                id: conversation._id,
            });
        }
    } catch (error) { }
    return res.status(500).json(errorJson('Internal error', 'Error finding conversation'));
};