const { StatusUnauthorized, StatusOK } = require('../../constants');
const { getMessages, isInConversation } = require('../../models');

module.exports = async (req, res) => {
  return (await getConversation(req.query.conversation)).participants.contains(
    res.locals.userId
  )
    ? res
        .status(StatusOK)
        .json(
          await getMessages(
            req.query.conversation,
            req.query.start ?? -1,
            req.query.limit ?? -1
          )
        )
    : res
        .status(StatusUnauthorized)
        .send('You are not a memebr of this conversation.');
};
