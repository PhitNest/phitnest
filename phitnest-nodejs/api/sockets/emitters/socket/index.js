const conversationEmitter = require('./conversation');

module.exports = (socket) => {
    conversationEmitter(socket);
}