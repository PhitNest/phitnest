const { messageModel } = require('../../../models/message');

module.exports = (io) => {
    messageModel.watch([{
        $match: {
            operationType: 'insert',
        }
    }], {
        fullDocument: 'updateLookup'
    }).on('change', async (doc) => {
        io.to(doc.fullDocument.conversation).emit('receiveMessage', {
            _id: doc.documentKey._id,
            conversation: doc.fullDocument.conversation,
            message: doc.fullDocument.message,
            sender: doc.fullDocument.sender,
            readBy: doc.fullDocument.readBy,
            createdAt: doc.fullDocument.createdAt,
        });
    });

    messageModel.watch([{
        $match: {
            operationType: 'delete',
        }
    }], {
        fullDocument: 'updateLookup'
    }).on('change', async (doc) => {
        io.to(doc.fullDocument.conversation).emit(`deleteMessage:${doc.documentKey._id}`);
    });

    messageModel.watch([{
        $match: {
            $and: [{ operationType: 'update', },
            {
                $or: [
                    { 'updateDescription.updatedFields.message': { $exists: true } },
                    { 'updateDescription.updatedFields.archived': { $exists: true } },
                    { 'updateDescription.updatedFields.readBy': { $exists: true } },
                ]
            }]
        }
    }], {
        fullDocument: 'updateLookup'
    }).on('change', async (doc) => {
        io.to(doc.fullDocument.conversation).emit(`updateMessage:${doc.documentKey._id}`, {
            message: doc.fullDocument.message,
            archived: doc.fullDocument.archived,
            readBy: doc.fullDocument.readBy,
        });
    })
}