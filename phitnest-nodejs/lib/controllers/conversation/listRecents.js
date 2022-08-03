const { conversationModel } = require("../../models");

module.exports = async (req, res) => {
  try {
    const messages = await conversationModel.aggregate([
      {
        $match: {
          participants: res.locals.userId,
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
            name: "$name",
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

    if (messages) {
      res.status(200).send(messages);
    } else {
      res.status(404).send("No messages found");
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
};
