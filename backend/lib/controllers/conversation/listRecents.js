module.exports = async (req, res) => {
  const conversationIds = await res.locals.redis.zrevrange(
    `users:${res.locals.userId}:conversations`,
    0,
    -1
  );

  const messageIds = await Promise.all(
    conversationIds.map(
      (id) =>
        res.locals.redis.zrevrange(`conversations:${id}:messages`, 0, 1)[0]
    )
  );

  res.status(200).json(
    await Promise.all(
      messageIds.map(async (id, index) => {
        const key = `messages:${id}`;
        const [sender, text] = await res.locals.redis
          .multi()
          .hget(key, 'sender')
          .hget(key, 'text')
          .exec();
        return {
          id: id,
          conversation: conversationIds[index],
          sender: sender,
          text: text,
        };
      })
    )
  );
};
