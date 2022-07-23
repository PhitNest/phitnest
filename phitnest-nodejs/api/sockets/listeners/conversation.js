const { conversationModel } = require('../../models/conversation');

module.exports = (socket) => {
    conversationModel.find({ participants: socket.data.userId, archived: false }).then((conversations) => {
        for (const conversation of conversations) {
            socket.join(conversation._id.toString());
        }
    });
}