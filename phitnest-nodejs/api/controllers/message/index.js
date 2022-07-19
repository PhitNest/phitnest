const sendMessage = require('./sendMessage');
const listMessages = require('./listMessages');
const deleteMessage = require('./deleteMessage');

module.exports = {
    sendMessage: sendMessage,
    listMessages: listMessages,
    deleteMessage: deleteMessage,
}