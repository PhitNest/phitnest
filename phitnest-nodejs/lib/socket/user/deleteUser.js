const {
  userCachePrefix,
  userCacheHours,
  conversationCachePrefix,
  conversationCacheHours,
  messageCachePrefix,
  conversationRecentMessagesCacheHours,
  conversationRecentMessagesCachePrefix,
} = require("../../constants");
const { userModel, conversationModel, messageModel } = require("../../models");
const { checkCacheOrQuery } = require("../helpers");

module.exports = (socket) =>
  socket.on("deleteUser", async (data) => {
    try {
      const user = await checkCacheOrQuery(
        socket.data.redis,
        userCachePrefix,
        userCacheHours,
        userModel,
        socket.data.userId
      );
      if (user) {
        await Promise.all([
          messageModel.find({ sender: user._id }).then((messages) =>
            messages.forEach(async (message) => {
              const conversationRecentMessagesCacheKey = `${conversationRecentMessagesCachePrefix}/${message.conversation}`;
              socket.data.redis
                .del(`${messageCachePrefix}/${message._id}`)
                .zrem(
                  conversationRecentMessagesCacheKey,
                  JSON.stringify(message)
                )
                .expire(
                  conversationRecentMessagesCacheKey,
                  60 * 60 * conversationRecentMessagesCacheHours
                )
                .exec();
              await message.delete();
              socket.broadcast
                .to(message.conversation.toString())
                .emit(`messageDeleted:${message._id}`);
            })
          ),
          conversationModel
            .find({
              participants: user._id,
            })
            .then((conversations) =>
              conversations.forEach(async (conversation) => {
                const index = conversation.participants.indexOf(user._id);
                conversation.participants.splice(index, 1);
                socket.data.redis.setex(
                  `${conversationCachePrefix}/${conversation._id}`,
                  60 * 60 * conversationCacheHours,
                  JSON.stringify(conversation)
                );
                await conversation.save();
                socket.broadcast
                  .to(conversation._id.toString())
                  .emit("userDeleted", { id: user._id });
              })
            ),
          async () => socket.data.redis.del(`${userCachePrefix}/${user._id}`),
          user.delete(),
        ]);
        socket.broadcast.to(`userListener:${user._id}`).emit("userDeleted", {});
      } else {
        socket.emit("error", "You are not authenticated.");
      }
    } catch (error) {
      socket.emit("error", error);
    }
  });
