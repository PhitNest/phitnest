const { messageModel } = require('../../models/message');
const { conversationModel } = require('../../models/conversation');
const { messageValidator } = require('./validators');
const joi = require('joi');

function validateMessage(data) {
    const schema = joi.object({
        conversation: joi.string(),
        message: messageValidator,
    });
    return schema.validate(data);
}

module.exports = (socket) => {
    socket.on('sendMessage', (data) => {
        const { error } = validateMessage(data);
        let errorMessage = '';
        if (error) {
            if (error.details[0].message.includes('conversation')) {
                errorMessage = 'Please provide a valid conversation id.';
            }
            else if (error.details[0].message.includes('message')) {
                errorMessage = 'Please provide a valid message.';
            }
            else {
                errorMessage = 'Please provide the required fields.';
            }
            socket.emit('error', errorMessage);
        } else {
            conversationModel.findById(data.conversation).then((conversation) => {
                if (conversation) {
                    let message = new messageModel({
                        conversation: data.conversation,
                        message: data.message,
                        sender: socket.data.userId,
                    });
                    message.save();
                } else {
                    socket.emit('error', 'This conversation does not exist.');
                }
            });
        }
    });

    socket.on('deleteMessage', (data) => {
        messageModel.findById(data.id).then((message) => {
            if (message && message.sender == socket.data.userId) {
                message.update({ archived: true });
            } else {
                socket.emit('error', 'You cannot delete this message.');
            }
        });
    });
}
