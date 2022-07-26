const userModel = require('./user');
const messageModel = require('./message');
const conversationModel = require('./conversation');

module.exports = {
    userModel: userModel,
    conversationModel: conversationModel,
    messageModel: messageModel,
}