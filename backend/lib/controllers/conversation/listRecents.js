const { StatusOK } = require('../../constants');
const { listRecentMessagesForUser } = require('../../models');

module.exports = async (req, res) => {
  return res
    .status(StatusOK)
    .json(await listRecentMessagesForUser(res.locals.userId));
};
