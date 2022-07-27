const { messageModel } = require('../../../models');
const joi = require('joi');
const objectId = require('joi-objectid')(joi);
const { getConversation } = require('../helpers');
const { minMessageLength, maxMessageLength, messageCacheHours, messageCachePrefix } = require('../../../constants');

function validate(data) {
    const schema = joi.object({
        conversation: objectId().required(),
        message: joi.string().trim().min(minMessageLength).max(maxMessageLength).required(),
    });
    return schema.validate(data);
}

module.exports = socket => {
    socket.on('sendMessage', async data => {
        const { error } = validate(data);
        if (error) {
            socket.emit('error', error);
        } else {
            try {
                const conversation = await getConversation(data.conversation, socket);
                if (conversation) {
                    const message = new messageModel({
                        conversation: data.conversation,
                        message: data.message,
                        sender: socket.data.userId,
                    });
                    await message.save();
                    const messageCacheKey = `${messageCachePrefix}/${message._id}`
                    socket.data.redis.set(messageCacheKey, JSON.stringify(message));
                    socket.data.redis.expire(messageCacheKey, 60 * 60 * messageCacheHours);
                    socket.broadcast.to(data.conversation).emit('receiveMessage', message);
                } else {
                    socket.emit('error', 'No conversation found');
                }
            } catch (error) {
                socket.emit('error', error);
            }
        }
    });
}