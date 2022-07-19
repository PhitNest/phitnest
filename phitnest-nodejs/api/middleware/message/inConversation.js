const { conversationModel } = require('../../models/conversation');

module.exports = async (req, res, next) => {
    try {
        const conversation = await conversationModel.findById(req.query.conversation);

        if (conversation && (res.locals.uid in conversation.participants)) {
            next();
        }
    } catch (error) { }
    return res.status(500).send('Error finding conversation');
};