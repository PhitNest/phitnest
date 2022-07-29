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

module.exports = (socket) => {
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
          user.delete(),
          messageModel.find({ sender: user._id }).forEach(async (message) => {
            const conversationRecentMessagesCacheKey = `${conversationRecentMessagesCachePrefix}/${message.conversation}`;
            const multi = socket.data.redis
              .del(`${messageCachePrefix}/${message._id}`)
              .zrem(conversationRecentMessagesCacheKey, JSON.stringify(message))
              .expire(
                conversationRecentMessagesCacheKey,
                60 * 60 * conversationRecentMessagesCacheHours
              );
            await Promise.all([message.delete(), multi.exec()]);
            socket.broadcast
              .to(message.conversation.toString())
              .emit(`messageDeleted:${message._id}`);
          }),
          conversationModel
            .find({
              participants: user._id,
            })
            .forEach(async (conversation) => {
              const index = conversation.participants.indexOf(user._id);
              conversation.participants.splice(index, 1);
              await Promise.all([
                conversation.save(),
                socket.data.redis.setex(
                  `${conversationCachePrefix}/${conversation._id}`,
                  60 * 60 * conversationCacheHours,
                  JSON.stringify(conversation)
                ),
              ]);
              socket.broadcast
                .to(conversation._id.toString())
                .emit("userDeleted", { id: user._id });
            }),
          socket.data.redis.del(`${userCachePrefix}/${user._id}`),
        ]);
        socket.broadcast.to(`userListener:${user._id}`).emit("userDeleted", {});
      } else {
        socket.emit("error", "You are not authenticated.");
      }
    } catch (error) {
      socket.emit("error", error);
    }
  });
};
