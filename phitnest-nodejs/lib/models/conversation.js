const mongoose = require('mongoose');

const conversationSchema = mongoose.Schema(
  {
    name: {
      type: String,
      trim: true,
      required: true,
    },
    participants: [
      { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    ],
  },
  { timestamps: true }
);

const conversationModel = mongoose.model('Conversation', conversationSchema);

module.exports = {
  conversationModel: conversationModel,
  createConversation: (input) => conversationModel.create(input),
};
