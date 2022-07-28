const { conversationModel } = require('../../models');
const { conversationCacheHours, conversationCachePrefix } = require('../../constants');

module.exports = async (req, res, next) => {
    try {
        let conversation = null;
        const conversationCache = await res.locals.redis.get(`${conversationCachePrefix}/${req.query.conversation}`);
        if (conversationCache) {
            conversation = conversationModel.hydrate(JSON.parse(conversationCache));
            res.locals.redis.expire(`${conversationCachePrefix}/${req.query.conversation}`, 60 * 60 * conversationCacheHours);
        } else {
            conversation = await conversationModel.findById(req.query.conversation);
        }
        if (conversation && conversation.participants.includes(res.locals.uid)) {
            next();
        } else {
            res.status(404).send('No conversation found.');
        }
    } catch (error) {
        res.status(500).send(error);
    }
}