const { userModel, createUser } = require('./user');
const { messageModel, createMessage } = require('./message');
const { conversationModel, createConversation } = require('./conversation');
const {
  userRelationshipModel,
  createUserRelationship,
} = require('./userRelationship');

module.exports = {
  userModel: userModel,
  createUser: createUser,
  conversationModel: conversationModel,
  createConversation: createConversation,
  messageModel: messageModel,
  createMessage: createMessage,
  userRelationshipModel: userRelationshipModel,
  createUserRelationship: createUserRelationship,
};
