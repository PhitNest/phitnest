const { conversationRecentMessagesCacheHours, conversationRecentMessagesCachePrefix } = require('../../constants');

module.exports = async (redis, conversationId) => {
    const conversationMessageCacheKey = `${conversationRecentMessagesCachePrefix}/${conversationId}`;
    const conversationMessageCache = await redis.get(conversationMessageCacheKey);
    if (conversationMessageCache) {
        redis.expire(conversationMessageCacheKey, 60 * 60 * conversationRecentMessagesCacheHours);
    }

    return JSON.parse(conversationMessageCache);
}