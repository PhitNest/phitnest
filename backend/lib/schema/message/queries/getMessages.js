const messageModel = require("../messageModel");

module.exports = (conversation, start, limit) =>
  messageModel
    .find({ conversation: conversation })
    .sort({ createdAt: -1 })
    .skip(start)
    .limit(limit)
    .exec();
