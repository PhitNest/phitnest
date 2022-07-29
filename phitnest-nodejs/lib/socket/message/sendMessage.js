const { messageModel, conversationModel } = require("../../models");
const joi = require("joi");
const objectId = require("joi-objectid")(joi);
const { checkCacheOrQuery } = require("../helpers");
const {
  minMessageLength,
  maxMessageLength,
  messageCacheHours,
  messageCachePrefix,
  conversationCachePrefix,
  conversationCacheHours,
  conversationRecentMessagesCachePrefix,
  conversationRecentMessagesCacheHours,
} = require("../../constants");

function validate(data) {
  const schema = joi.object({
    conversation: objectId().required(),
    message: joi
      .string()
      .trim()
      .min(minMessageLength)
      .max(maxMessageLength)
      .required(),
  });
  return schema.validate(data);
}

module.exports = (socket) => {
  socket.on("sendMessage", async (data) => {
    const { error } = validate(data);
    if (error) {
      socket.emit("error", error);
    } else {
      try {
        const conversation = await checkCacheOrQuery(
          socket.data.redis,
          conversationCachePrefix,
          conversationCacheHours,
          conversationModel,
          data.conversation
        );
        if (
          conversation &&
          conversation.participants.includes(socket.data.userId)
        ) {
          const message = new messageModel({
            conversation: data.conversation,
            message: data.message,
            sender: socket.data.userId,
          });
          await Promise.all([
            message.save(),
            socket.data.redis.zAdd(
              `${conversationRecentMessagesCachePrefix}/${conversation._id}`,
              { score: message.createdAt, value: JSON.stringify(message) },
              { EX: 60 * 60 * conversationRecentMessagesCacheHours }
            ),
            socket.data.redis.set(
              `${messageCachePrefix}/${message._id}`,
              JSON.stringify(message),
              {
                EX: 60 * 60 * messageCacheHours,
              }
            ),
          ]);
          socket.broadcast
            .to(data.conversation)
            .emit("receiveMessage", message);
        } else {
          socket.emit("error", "No conversation found");
        }
      } catch (error) {
        socket.emit("error", error);
      }
    }
  });
};
