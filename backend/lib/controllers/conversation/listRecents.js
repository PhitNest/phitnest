module.exports = async (req, res) => {
  const { getConversationIds } = require('../../schema/user')(res.locals.redis);
  const { getFirstMessageIdsFromEachConversation } =
    require('../../schema/conversation')(res.locals.redis);
  const { getMessagesByIds } = require('../../schema/message')(
    res.locals.redis
  );
  res
    .status(200)
    .json(
      await getMessagesByIds(
        await getFirstMessageIdsFromEachConversation(
          await getConversationIds(res.locals.userId)
        )
      )
    );
};
