const conversationListener = require('./conversation');
const messageListener = require('./message');

module.exports = (socket) => {
    conversationListener(socket);
    messageListener(socket);
};