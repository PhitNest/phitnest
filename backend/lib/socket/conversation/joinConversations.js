module.exports = async (socket) =>
  socket.data.redis
    .zrevrange(`users:${socket.data.userId}:conversations`, 0, -1)
    .then((conversations) =>
      conversations.forEach((conversation) => socket.join(conversation))
    );
