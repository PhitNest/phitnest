const userModel = require("./user");
const messageModel = require("./message");
const conversationModel = require("./conversation");
const userRelationshipModel = require("./userRelationship");

module.exports = {
  userModel: userModel,
  conversationModel: conversationModel,
  messageModel: messageModel,
  userRelationshipModel: userRelationshipModel,
};
