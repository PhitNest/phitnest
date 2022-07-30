const joi = require("joi");
const objectId = require("joi-objectid")(joi);
const { messageModel, conversationModel } = require("../../models");
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
const { checkCacheOrQuery } = require("../helpers");

function validate(data) {
  const schema = joi.object({
    message: objectId().required(),
    text: joi
      .string()
      .trim()
      .min(minMessageLength)
      .max(maxMessageLength)
      .required(),
  });
  return schema.validate(data);
}

module.exports = (socket) => {
  socket.on("updateMessage", async (data) => {
    const { error } = validate(data);
    if (error) {
      socket.emit("error", error);
    } else {
      try {
        const message = await checkCacheOrQuery(
          socket.data.redis,
          messageCachePrefix,
          messageCacheHours,
          messageModel,
          data.message
        );
        if (message) {
          const conversation = await checkCacheOrQuery(
            socket.data.redis,
            conversationCachePrefix,
            conversationCacheHours,
            conversationModel,
            message.conversation
          );
          if (
            conversation &&
            conversation.participants.includes(socket.data.userId)
          ) {
            const oldMessageStringified = JSON.stringify(message);
            message.message = data.text;
            const newMessageStringified = JSON.stringify(message);
            const conversationRecentMessagesCacheKey = `${conversationRecentMessagesCachePrefix}/${conversation._id}`;
            const multi = socket.data.redis
              .multi()
              .zrem(conversationRecentMessagesCacheKey, oldMessageStringified)
              .zadd(
                conversationRecentMessagesCacheKey,
                message.createdAt,
                newMessageStringified
              )
              .expire(
                conversationRecentMessagesCacheKey,
                60 * 60 * conversationRecentMessagesCacheHours
              )
              .setex(
                `${messageCachePrefix}/${message._id}`,
                60 * 60 * messageCacheHours,
                newMessageStringified
              )
              .exec();
            await message.save();
            socket.broadcast
              .to(message.conversation)
              .emit(`messageUpdated:${message._id}`, message);
          } else {
            socket.emit("error", "No conversation found");
          }
        } else {
          socket.emit("error", "No message found");
        }
      } catch (error) {
        socket.emit("error", error);
      }
    }
  });
};
