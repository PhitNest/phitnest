const { messageModel } = require('../../models');
const { conversationRecentMessagesCachePrefix, conversationRecentMessagesCacheHours } = require('../../constants');

module.exports = async (req, res) => {
    try {
        const conversationRecentMessagesCacheKey = `${conversationRecentMessagesCachePrefix}/${req.query.conversation}`;
        const conversationRecentMessagesCache = await res.locals.redis.get(conversationRecentMessagesCacheKey);
        let messages = [];
        if (conversationRecentMessagesCache) {
            const conversationRecentMessagesCacheList = await res.locals.redis.lrange(conversationRecentMessagesCacheKey, 0, req.query.limit);
            res.locals.redis.expire(conversationRecentMessagesCacheKey, 60 * 60 * conversationRecentMessagesCacheHours);
            JSON.parse(conversationRecentMessagesCacheList).forEach(messageJson => messages.push(messageModel.hydrate(messageJson)));
        }
        if (messages.length < req.query.limit) {
            (await messageModel.aggregate([{
                $match:
                    { conversation: res.locals.conversation._id }
            },
            { $sort: { createdAt: -1 } },
            { $limit: parseInt(req.query.limit) },
            { $skip: messages.length }
            ])).forEach(message => {
                messages.push(message);
            });
        }
        res.status(200).json(messages);
    } catch (error) {
        console.log(error);
        res.status(500).send(error);
    }
}