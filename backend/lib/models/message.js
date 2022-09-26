const mongoose = require('mongoose');

const messageSchema = mongoose.Schema(
  {
    conversation: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Conversation',
      required: true,
    },
    sender: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    text: {
      type: String,
      trim: true,
      required: true,
    },
  },
  { timestamps: true }
);

const messageModel = mongoose.model('Message', messageSchema);

module.exports = {
  messageModel: messageModel,
  getMessages: (conversation, start, limit) =>
    messageModel
      .find({ conversation: conversation })
      .sort({ createdAt: -1 })
      .skip(start)
      .limit(limit)
      .exec(),
  createMessage: (input) => messageModel.create(input),
};
