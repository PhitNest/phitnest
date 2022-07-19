const { conversationModel } = require('../../models/conversation');

module.exports = (socket) => {
    conversationModel.find({ participants: socket.data.userId, archived: false }).then((conversations) => {
        for (const conversation in conversations) {
            socket.join(conversation._id);
        }
    });
}