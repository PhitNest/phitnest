const joi = require('joi');
const objectId = require('joi-objectid')(joi);
const { messageModel, conversationModel } = require('../../models');
const { minMessageLength, maxMessageLength, messageCacheHours, messageCachePrefix, conversationCachePrefix, conversationCacheHours, conversationRecentMessagesCachePrefix, conversationRecentMessagesCacheHours } = require('../../constants');
const { checkCacheOrQuery, getConversationMessageCache } = require('../helpers');

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
                const message = await checkCacheOrQuery(socket.data.redis, messageCachePrefix, messageCacheHours, messageModel, data.message);
                if (message) {
                    const conversation = await checkCacheOrQuery(socket.data.redis, conversationCachePrefix, conversationCacheHours, conversationModel, message.conversation);
                    if (conversation && conversation.participants.includes(socket.data.userId)) {
                        message.message = data.text;
                        let promise = message.save();
                        const conversationMessageCacheKey = `${conversationRecentMessagesCachePrefix}/${conversation._id}`;
                        const conversationMessageCache = await getConversationMessageCache(socket.data.redis, conversation._id);
                        if (conversationMessageCache) {
                            const spliceIndex = conversationMessageCache.indexOf(JSON.stringify(message));
                            conversationMessageCache.splice(spliceIndex, 1);
                            socket.data.redis.set(conversationMessageCacheKey, conversationMessageCache);
                            socket.data.redis.expire(conversationMessageCacheKey, 60 * 60 * conversationRecentMessagesCacheHours);
                        }
                        const messageCacheKey = `${messageCachePrefix}/${message._id}`
                        socket.data.redis.set(messageCacheKey, JSON.stringify(message));
                        socket.data.redis.expire(messageCacheKey, 60 * 60 * messageCacheHours);
                        await promise;
                        socket.broadcast.to(message.conversation).emit(`messageUpdated:${message._id}`, message);
                    } else {
                        socket.emit('error', 'No conversation found');
                    }
                } else {
                    socket.emit('error', 'No message found');
                }
            } catch (error) {
                socket.emit('error', error);
            }
        }
    });
}