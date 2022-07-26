const registerChat = require('./chat');

module.exports = socket => {
    registerChat(socket);
}