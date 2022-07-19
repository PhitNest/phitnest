const { conversationModel } = require('../../models/conversation');

module.exports = async (req, res) => {
    try {
        const conversations = await conversationModel.find(
            { participants: res.locals.uid, archived: false }
        ).limit(parseInt(req.query.limit));
        if (conversations) {
            return res.status(200).json(
                conversations.map((conversation) => {
                    return {
                        id: conversation._id,
                        participants: conversation.participants,
                    }
                }));
        }
    } catch (error) { }

    return res.status(500).send('Invalid query');
}