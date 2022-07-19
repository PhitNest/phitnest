const { messageModel } = require('../../models/message');

module.exports = async (req, res) => {
    try {
        const message = await messageModel.findById(req.query.id);
        if (message && message.sender == res.locals.uid) {
            message.archived = true;
            message.save();
            return res.status(200).send('Archived');
        }
    } catch (error) { }

    return res.status(500).send('The query contained an invalid message id.');
}