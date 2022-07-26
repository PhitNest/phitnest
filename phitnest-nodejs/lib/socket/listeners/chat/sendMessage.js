const { messageModel, conversationModel } = require('../../../models');
const joi = require('joi');
const { minMessageLength, maxMessageLength, conversationCacheHours, conversationCachePrefix } = require('../../../constants');


function validate(data) {
    const schema = joi.object({
        conversation: joi.string().required(),
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
                const conversationCacheKey = `${conversationCachePrefix}/${data.conversation}`;
                const conversationCache = await socket.data.redis.get(conversationCacheKey);
                let conversation = null;
                if (conversationCache) {
                    conversation = JSON.parse(conversationCache);
                    if (!(conversation.participants.includes(socket.data.userId.toString()))) {
                        conversation = null;
                    }
                } else {
                    conversation = await conversationModel.findById(data.conversation).where({ participants: socket.data.userId });
                }
                if (conversation) {
                    socket.data.redis.set(conversationCacheKey, JSON.stringify(conversation));
                    socket.data.redis.expire(conversationCacheKey, 60 * 60 * conversationCacheHours);
                    const message = new messageModel({
                        conversation: data.conversation,
                        message: data.message,
                        sender: socket.data.userId,
                    });
                    await message.save();
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