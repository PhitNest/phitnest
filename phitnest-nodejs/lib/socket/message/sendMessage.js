const { messageModel, conversationModel } = require('../../models');
const joi = require('joi');
const objectId = require('joi-objectid')(joi);
const { checkCacheOrQuery, getConversationMessageCache } = require('../helpers');
const { minMessageLength, maxMessageLength, messageCacheHours, messageCachePrefix, conversationCachePrefix, conversationCacheHours, conversationRecentMessagesCachePrefix, conversationRecentMessagesCacheHours } = require('../../constants');

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
                const conversation = await checkCacheOrQuery(socket.data.redis, conversationCachePrefix, conversationCacheHours, conversationModel, data.conversation);
                if (conversation && conversation.participants.includes(socket.data.userId)) {
                    const message = new messageModel({
                        conversation: data.conversation,
                        message: data.message,
                        sender: socket.data.userId,
                    });
                    let promise = message.save();
                    const messageCacheKey = `${messageCachePrefix}/${message._id}`;
                    const conversationMessageCacheKey = `${conversationRecentMessagesCachePrefix}/${conversation._id}`;
                    const conversationMessageCache = await getConversationMessageCache(socket.data.redis, message.conversation);
                    if (conversationMessageCache) {
                        socket.data.redis.lpush(conversationMessageCacheKey, JSON.stringify(message));
                    } else {
                        socket.data.redis.set(conversationMessageCacheKey, [JSON.stringify(message)]);
                    }
                    socket.data.redis.expire(conversationMessageCacheKey, 60 * 60 * conversationRecentMessagesCacheHours);
                    socket.data.redis.set(messageCacheKey, JSON.stringify(message));
                    socket.data.redis.expire(messageCacheKey, 60 * 60 * messageCacheHours);
                    await promise;
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