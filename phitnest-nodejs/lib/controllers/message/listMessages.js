const { messageModel } = require('../../models');
const { conversationRecentMessagesCachePrefix, conversationRecentMessagesCacheHours } = require('../../constants');

module.exports = async (req, res) => {
    try {
        const conversationRecentMessagesCacheKey = `${conversationRecentMessagesCachePrefix}/${req.query.conversation}`;
        const conversationRecentMessagesCache = await res.locals.redis.lrange(conversationRecentMessagesCacheKey, 0, req.query.limit);
        let messages = [];
        if (conversationRecentMessagesCache) {
            res.locals.redis.expire(conversationRecentMessagesCacheKey, 60 * 60 * conversationRecentMessagesCacheHours);
            JSON.parse(conversationRecentMessagesCache).forEach(messageJson => messages.push(messageModel.hydrate(messageJson)));
        }
        messages.push(await messageModel.find({ conversation: req.query.conversation }).sort({ createdAt: -1 }).slice(messages.length, req.query.limit));
        res.status(200).json(messages);
    } catch (error) {
        res.status(500).send(error);
    }
}