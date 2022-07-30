const { messageModel } = require("../../models");
const {
  conversationRecentMessagesCachePrefix,
  conversationRecentMessagesCacheHours,
} = require("../../constants");

module.exports = async (req, res) => {
  try {
    const conversationRecentMessagesCacheKey = `${conversationRecentMessagesCachePrefix}/${req.query.conversation}`;
    const conversationRecentMessagesCache = await res.locals.redis.zrange(
      conversationRecentMessagesCacheKey,
      0,
      req.query.limit
    );
    let messages = [];
    if (conversationRecentMessagesCache.length) {
      res.locals.redis.expire(
        conversationRecentMessagesCacheKey,
        60 * 60 * conversationRecentMessagesCacheHours
      );
      JSON.parse(conversationRecentMessagesCache).forEach((messageJson) =>
        messages.push(messageModel.hydrate(messageJson))
      );
    }
    if (messages.length < req.query.limit) {
      const multi = res.locals.redis.multi();
      (
        await messageModel.aggregate([
          {
            $match: { conversation: res.locals.conversation._id },
          },
          { $sort: { createdAt: -1 } },
          { $limit: parseInt(req.query.limit) },
          { $skip: messages.length },
        ])
      ).forEach((message) => {
        multi.zadd(
          conversationRecentMessagesCacheKey,
          Number(message.createdAt),
          JSON.stringify(message)
        );
        messages.push(message);
      });
      multi.expire(
        conversationRecentMessagesCacheKey,
        60 * 60 * conversationRecentMessagesCacheHours
      );
      multi.exec();
    }
    res.status(200).json(messages);
  } catch (error) {
    res.status(500).send(error.message);
  }
};
