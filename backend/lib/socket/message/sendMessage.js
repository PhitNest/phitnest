module.exports = async (socket) => {
  socket.on('sendMessage', (data) => {
    socket.emit('receiveMessage', {});
  });
};
