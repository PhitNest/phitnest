const { userModel } = require('../../models/user');

module.exports = (io) => {
    userModel.watch().on('change', async (doc) => {
        try {
            const user = await userModel.findById(doc.documentKey._id);
            if (user) {
                io.emit(`userSubscription:${user._id}`, {
                    firstName: user.firstName,
                    lastName: user.lastName,
                    bio: user.bio,
                    online: user.online,
                });
            }
        } catch (error) { }
    });
};