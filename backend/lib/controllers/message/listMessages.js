const { StatusUnauthorized, StatusOK } = require("../../constants");
const { message, conversation } = require("../../schema");

module.exports = async (req, res) => {
  return (
    await conversation.queries.getConversation(req.query.conversation)
  ).participants.contains(res.locals.userId)
    ? res
        .status(StatusOK)
        .json(
          await message.queries.getMessages(
            req.query.conversation,
            req.query.start ?? -1,
            req.query.limit ?? -1
          )
        )
    : res
        .status(StatusUnauthorized)
        .send("You are not a memebr of this conversation.");
};
