const { userModel } = require('../../../models/user');

module.exports = (io) => {
    userModel.watch([{
        $match: {
            $and: [
                { operationType: 'update' },
                {
                    $or: [
                        { 'updateDescription.updatedFields.firstName': { $exists: true } },
                        { 'updateDescription.updatedFields.lastName': { $exists: true } },
                        { 'updateDescription.updatedFields.bio': { $exists: true } },
                        { 'updateDescription.updatedFields.online': { $exists: true } },
                    ]
                }
            ]
        }
    }], {
        fullDocument: 'updateLookup'
    }).on('change', async (doc) => {
        io.emit(`publicInfoStream:${doc.documentKey._id}`, {
            firstName: doc.fullDocument.firstName,
            lastName: doc.fullDocument.lastName,
            bio: doc.fullDocument.bio,
            online: doc.fullDocument.online,
        });
    });
};