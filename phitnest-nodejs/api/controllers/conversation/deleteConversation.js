const { conversationModel } = require('../../models/conversation');

module.exports = async (req, res) => {
    try {
        const conversation = await conversationModel.findById(req.query.id);
        if (conversation && (res.locals.uid in conversation.participants)) {
            conversation.archived = true;
            conversation.save();
            return res.status(200).send('Archived');
        }
    } catch (error) { }

    return res.status(500).send('The query contained an invalid conversation id.');
}