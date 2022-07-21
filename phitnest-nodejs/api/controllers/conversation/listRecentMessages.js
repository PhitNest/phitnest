const { conversationModel } = require('../../models/conversation');
const { messageModel } = require('../../models/message');

module.exports = async (req, res) => {
    try {
        const messages = await conversationModel.aggregate([
            { $match: { participants: res.locals.uid } },
            {
                $lookup: {
                    from: "messages",
                    localField: "_id",
                    foreignField: "conversation",
                    as: "recentMessage"
                }
            },
            { $unwind: "$recentMessage" },
            { $sort: { "recentMessage.createdAt": -1 } },
            {
                $project: {
                    conversation: {
                        _id: "$_id",
                        participants: "$participants"
                    },
                    message: "$recentMessage"
                }
            },
            {
                $group: {
                    _id: "$conversation._id",
                    conversation: {
                        $first: "$conversation"
                    },
                    message: {
                        $first: "$message"
                    }
                }
            }
        ]);

        if (messages) {
            return res.status(200).json(messages);
        }
    } catch (error) {
    }

    return res.status(500).send('This query failed');
}