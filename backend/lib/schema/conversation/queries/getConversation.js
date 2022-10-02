const conversationModel = require("../conversationModel");

module.exports = (conversationId) =>
  conversationModel.findOne({ _id: conversationId });
