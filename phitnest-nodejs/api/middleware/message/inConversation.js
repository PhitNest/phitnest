const { conversationModel } = require('../../models/conversation');

module.exports = async (req, res, next) => {
    try {
        const conversation = await conversationModel.findById(req.body.conversation || req.query.conversation);
        if (conversation && (conversation.participants.find((val) => val == res.locals.uid))) {
            next();
            return;
        }
    } catch (error) { }
    return res.status(500).send('Error finding conversation');
};