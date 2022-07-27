const joi = require('joi');
const objectId = require('joi-objectid')(joi);
const { messageModel } = require('../../../models');
const { minMessageLength, maxMessageLength, messageCacheHours, messageCachePrefix } = require('../../../constants');
const { getConversation, getMessage } = require('../helpers');

function validate(data) {
    const schema = joi.object({
        message: objectId().required(),
        text: joi.string().trim().min(minMessageLength).max(maxMessageLength).required(),
    });
    return schema.validate(data);
}

module.exports = socket => {
    socket.on('updateMessage', async data => {
        const { error } = validate(data);
        if (error) {
            socket.emit('error', error);
        } else {
            try {
                const message = await getMessage(data.message, socket);
                if (message) {
                    const conversation = await getConversation(message.conversation, socket);
                    if (conversation) {
                        message.message = data.text;
                        await message.save();
                        const messageCacheKey = `${messageCachePrefix}/${message._id}`
                        socket.data.redis.set(messageCacheKey, JSON.stringify(message));
                        socket.data.redis.expire(messageCacheKey, 60 * 60 * messageCacheHours);
                        socket.broadcast.to(message.conversation).emit(`messageUpdated:${message._id}`, message);
                    } else {
                        socket.emit('error', 'No conversation found');
                    }
                } else {
                    socket.emit('error', 'No message found');
                }
            } catch (error) {
                console.log(error);
                socket.emit('error', error);
            }
        }
    });
}