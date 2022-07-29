const { conversationModel } = require("../../models");
const {
  conversationCacheHours,
  conversationCachePrefix,
} = require("../../constants");

module.exports = async (req, res, next) => {
  try {
    const conversationCacheKey = `${conversationCachePrefix}/${req.query.conversation}`;
    let conversation;
    const conversationCache = await res.locals.redis.get(conversationCacheKey);
    if (conversationCache) {
      conversation = conversationModel.hydrate(JSON.parse(conversationCache));
    } else {
      conversation = await conversationModel.findById(req.query.conversation);
    }
    if (conversation && conversation.participants.includes(res.locals.userId)) {
      await res.locals.redis.set(
        conversationCacheKey,
        JSON.stringify(conversation),
        { EX: 60 * 60 * conversationCacheHours }
      );
      res.locals.conversation = conversation;
      next();
    } else {
      res.status(404).send("No conversation found.");
    }
  } catch (error) {
    res.status(500).send(error);
  }
};
