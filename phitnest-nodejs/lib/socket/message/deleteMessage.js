const joi = require('joi');
const objectId = require('joi-objectid')(joi);
const { messageCachePrefix, conversationCachePrefix, conversationCacheHours, conversationRecentMessagesCacheHours, conversationRecentMessagesCachePrefix } = require('../../constants');
const { conversationModel, messageModel } = require('../../models');
const { checkCacheOrQuery, getConversationMessageCache } = require('../helpers');

function validate(data) {
    const schema = joi.object({
        message: objectId().required(),
    });
    return schema.validate(data);
}

module.exports = socket => {
    socket.on('deleteMessage', async data => {
        const { error } = validate(data);
        if (error) {
            socket.emit('error', error);
        } else {
            try {
                const message = await checkCacheOrQuery(socket.data.redis, messageCachePrefix, messageCacheHours, messageModel, data.message);
                if (message) {
                    const conversation = await checkCacheOrQuery(socket.data.redis, conversationCachePrefix, conversationCacheHours, conversationModel, message.conversation);
                    if (conversation && conversation.participants.includes(socket.data.userId)) {
                        let promise = message.delete();
                        const conversationMessageCacheKey = `${conversationRecentMessagesCachePrefix}/${conversation._id}`;
                        const conversationCache = await getConversationMessageCache(conversation._id);
                        if (conversationCache) {
                            socket.data.redis.lrem(conversationMessageCacheKey, 0, JSON.stringify(message));
                        }
                        const messageCacheKey = `${messageCachePrefix}/${message._id}`
                        socket.data.redis.del(messageCacheKey);
                        await promise;
                        socket.broadcast.to(message.conversation).emit(`messageDeleted:${message._id}`);
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