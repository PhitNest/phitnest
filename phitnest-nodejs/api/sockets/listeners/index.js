const conversationListener = require('./conversation');

module.exports = (socket) => {
    conversationListener(socket);
};