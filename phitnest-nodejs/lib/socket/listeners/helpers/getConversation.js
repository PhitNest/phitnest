const { conversationModel } = require('../../../models');
const { conversationCacheHours, conversationCachePrefix } = require('../../../constants');

module.exports = async (conversationId, socket) => {
    const conversationCacheKey = `${conversationCachePrefix}/${conversationId}`;
    const conversationCache = await socket.data.redis.get(conversationCacheKey);
    let conversation = null;
    if (conversationCache) {
        conversation = conversationModel.hydrate(JSON.parse(conversationCache));
        if (!(conversation.participants.includes(socket.data.userId.toString()))) {
            conversation = null;
        }
    } else {
        conversation = await conversationModel.findById(conversationId).where({ participants: socket.data.userId });
    }
    if (conversation) {
        socket.data.redis.set(conversationCacheKey, JSON.stringify(conversation));
        socket.data.redis.expire(conversationCacheKey, 60 * 60 * conversationCacheHours);
    }
    return conversation;
}