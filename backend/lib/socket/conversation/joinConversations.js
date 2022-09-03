module.exports = (socket) =>
  socket.data.redis
    .zrange(`users:${socket.data.userId}:conversations`, 0, -1)
    .then((conversations) =>
      conversations.forEach((conversation) => socket.join(conversation))
    );
