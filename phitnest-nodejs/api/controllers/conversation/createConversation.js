const { conversationModel } = require('../../models/conversation');

module.exports = async (req, res) => {
    let conversation = new conversationModel({
        participants: [res.locals.uid, req.body.otherUser],
    });

    try {
        conversation = await conversation.save()
        return res.status(200).json({
            id: conversation._id,
        });
    } catch (error) {
        return res
            .status(500).send('An internal server error occurred while creating conversation.');
    }
};