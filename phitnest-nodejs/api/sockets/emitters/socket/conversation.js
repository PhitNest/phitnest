const { conversationModel } = require('../../../models/conversation');

module.exports = (socket) => {
    conversationModel.watch([{
        $match: {
            $and: [{ operationType: { $in: ['insert', 'update'] } },
            { "updateDescription.updatedFields.participants": socket.data.userId }]
        }
    }], {
        fullDocument: 'updateLookup'
    }).on('change', async (doc) => {
        socket.join(doc.documentKey._id);
        socket.emit('addedToConversation', {
            _id: doc.documentKey._id,
        });
    });
}