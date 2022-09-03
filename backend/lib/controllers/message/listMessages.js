module.exports = async (req, res) => {
  if (
    await res.locals.redis.sismember(
      `conversations:${req.query.conversation}:participants`,
      res.locals.userId
    )
  ) {
    const messageIds = await res.locals.redis.zrevrange(
      `conversations:${req.query.conversation}:messages`,
      0,
      req.query.limit
    );

    res.status(200).json(
      await Promise.all(
        messageIds.map(async (id) => {
          const key = `messages:${id}`;
          const [sender, text] = await res.locals.redis
            .multi()
            .hget(key, 'sender')
            .hget(key, 'text')
            .exec();
          return {
            id: id,
            sender: sender,
            text: text,
          };
        })
      )
    );
  } else {
    res.status(500).send('You are not a memebr of this conversation.');
  }
};
