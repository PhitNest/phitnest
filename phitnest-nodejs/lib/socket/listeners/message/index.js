const sendMessage = require('./sendMessage');
const deleteMessage = require('./deleteMessage');
const updateMessage = require('./updateMessage');

module.exports = socket => {
    sendMessage(socket);
    deleteMessage(socket);
    updateMessage(socket);
}