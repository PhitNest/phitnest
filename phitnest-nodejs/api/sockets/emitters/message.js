const { messageModel } = require('../../models/message');

module.exports = (io) => {
    messageModel.watch([{
        $match: {
            operationType: 'insert',
        }
    }], {
        fullDocument: 'updateLookup'
    }).on('change', async (doc) => {
        const message = doc.fullDocument;
        io.emit(`conversationStream:${message.conversation}`, {
            message: message.message,
            sender: message.sender,
        });
    });
}