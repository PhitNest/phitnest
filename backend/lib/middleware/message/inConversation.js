module.exports = async (req, res, next) => {
  if (
    await res.locals.redis.sismember(
      `conversations:${req.query.conversation}:participants`,
      res.locals.userId
    )
  ) {
    next();
  } else {
    res.status(500).send('You are not part of this conversation.');
  }
};
