const { StatusOK } = require("../../constants");
const { conversation } = require("../../schema");

module.exports = async (req, res) => {
  return res
    .status(StatusOK)
    .json(
      await conversation.queries.listRecentMessagesForUser(res.locals.userId)
    );
};
