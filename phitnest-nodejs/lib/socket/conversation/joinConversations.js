const { conversationModel } = require("../../models");

module.exports = (socket) =>
  conversationModel
    .find({ participants: socket.data.userId })
    .then((conversations) =>
      conversations.forEach((conversation) =>
        socket.join(conversation._id.toString())
      )
    );
