const mongoose = require('mongoose');

const conversationSchema = mongoose.Schema(
  {
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
  getConversation: (conversationId) =>
    conversationModel.findOne({ _id: conversationId }),
  listRecentMessagesForUser: (userId) =>
    conversationModel.aggregate([
      {
        $match: {
          participants: userId,
        },
      },
      {
        $lookup: {
          from: 'messages',
          let: { conversationId: '$conversation' },
          pipeline: [{ $match: { $expr: [{ _id: '$$conversationId' }] } }],
          as: 'recentMessage',
        },
      },
      { $unwind: '$recentMessage' },
      { $sort: { 'recentMessage.createdAt': -1 } },
      {
        $project: {
          conversation: {
            _id: '$_id',
            participants: '$participants',
          },
          message: '$recentMessage',
        },
      },
      {
        $group: {
          _id: '$conversation._id',
          conversation: {
            $first: '$conversation',
          },
          message: {
            $first: '$message',
          },
        },
      },
    ]),
};
