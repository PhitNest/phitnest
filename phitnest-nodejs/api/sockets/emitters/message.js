const { messageModel } = require('../../models/message');

module.exports = (io) => {
    messageModel.watch([{
        $match: {
            operationType: 'insert',
        }
    }], {
        fullDocument: 'updateLookup'
    }).on('change', async (doc) => {
        io.emit(`conversationStream:${doc.fullDocument.conversation}`, {
            id: doc.documentKey._id,
            message: doc.fullDocument.message,
            sender: doc.fullDocument.sender,
        });
    });
}