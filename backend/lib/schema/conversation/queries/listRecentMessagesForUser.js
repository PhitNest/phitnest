const conversationModel = require("../conversationModel");

module.exports = (userId) =>
  conversationModel.aggregate([
    {
      $match: {
        participants: userId,
      },
    },
    {
      $lookup: {
        from: "messages",
        let: { conversationId: "$conversation" },
        pipeline: [{ $match: { $expr: [{ _id: "$$conversationId" }] } }],
        as: "recentMessage",
      },
    },
    { $unwind: "$recentMessage" },
    { $sort: { "recentMessage.createdAt": -1 } },
    {
      $project: {
        conversation: {
          _id: "$_id",
          participants: "$participants",
        },
        message: "$recentMessage",
      },
    },
    {
      $group: {
        _id: "$conversation._id",
        conversation: {
          $first: "$conversation",
        },
        message: {
          $first: "$message",
        },
      },
    },
  ]);
