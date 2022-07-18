const { userModel } = require('../../models/user');

module.exports = (io) => {
    userModel.watch().on('change', async (doc) => {
        const updates = doc.updateDescription.updatedFields;
        if (updates.firstName || updates.lastName || updates.bio || updates.online) {
            const user = await userModel.findById(doc.documentKey._id);
            if (user) {
                io.emit(`publicInfoStream:${user._id}`, {
                    firstName: user.firstName,
                    lastName: user.lastName,
                    bio: user.bio,
                    online: user.online,
                });
            }
        }
    });
};