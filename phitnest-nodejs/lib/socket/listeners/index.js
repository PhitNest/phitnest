const registerMessage = require('./message');
const registerConversation = require('./conversation');
const registerUser = require('./user');

module.exports = socket => {
    registerMessage(socket);
    registerConversation(socket);
    registerUser(socket);
}