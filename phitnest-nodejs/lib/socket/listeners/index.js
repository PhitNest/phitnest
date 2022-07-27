const registerMessage = require('./message');
const registerConversation = require('./conversation');

module.exports = socket => {
    registerMessage(socket);
    registerConversation(socket);
}