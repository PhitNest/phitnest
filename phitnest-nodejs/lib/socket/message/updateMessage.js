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
            await Promise.all([
              message.save(),
              socket.data.redis.socket.data.redis.zRem(
                `${conversationRecentMessagesCachePrefix}/${conversation._id}`,
                oldMessageStringified,
                { EX: 60 * 60 * conversationRecentMessagesCacheHours }
              ),
              socket.data.redis.socket.data.redis.set(
                `${messageCachePrefix}/${message._id}`,
                JSON.stringify(message),
                {
                  EX: 60 * 60 * messageCacheHours,
                }
              ),
            ]);
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
