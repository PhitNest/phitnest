const { StatusUnauthorized, StatusOK } = require('../../constants');

module.exports = async (req, res) => {
  const { isMember, getMessageIds } = require('../../schema/conversation')(
    res.locals.redis
  );
  const { getMessagesByIds } = require('../../schema/message')(
    res.locals.redis
  );
  if (await isMember(req.query.conversation, res.locals.userId)) {
    res
      .status(StatusOK)
      .json(
        await getMessagesByIds(
          getMessageIds(req.query.conversation, 0, req.query.limit)
        )
      );
  } else {
    res
      .status(StatusUnauthorized)
      .send('You are not a memebr of this conversation.');
  }
};
