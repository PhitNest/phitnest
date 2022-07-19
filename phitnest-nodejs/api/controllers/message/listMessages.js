const { messageModel } = require('../../models/message');

module.exports = async (req, res) => {
    try {
        const messages = await messageModel.find(
            { conversation: req.query.conversation, archived: false })
            .sort({ createdAt: (req.query.descending ? -1 : 1) }).limit(parseInt(req.query.limit));
        if (messages) {
            return res.status(200).json(
                messages.map((message) => {
                    return {
                        id: message._id,
                        sender: message.sender,
                        message: message.message,
                        sentAt: message.createdAt,
                        readBy: message.readBy,
                    }
                }));
        }
    } catch (error) { }

    return res.status(500).send('The query contained an invalid conversation id.');
}