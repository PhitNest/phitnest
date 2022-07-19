const { messageModel } = require('../../models/message');

module.exports = async (req, res) => {
    let message = new messageModel({
        conversation: req.body.conversation,
        message: req.body.message,
        sender: res.locals.uid,
    });

    try {
        message = await message.save()
        return res.status(200).json({
            id: message._id,
        });
    } catch (error) {
        return res
            .status(500).send('An internal server error while sending message.');
    }
};