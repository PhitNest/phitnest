const { userCachePrefix, userCacheHours, conversationCachePrefix, conversationCacheHours, messageCachePrefix } = require('../../constants');
const { userModel, conversationModel, messageModel } = require('../../models');
const { checkCacheOrQuery } = require('../helpers');

module.exports = socket => {
    socket.on('deleteUser', async data => {
        try {
            const user = await checkCacheOrQuery(socket.data.redis, userCachePrefix, userCacheHours, userModel, socket.data.userId);
            if (user) {
                await user.delete();
                const messages = await messageModel.find({ sender: user._id });
                messages.forEach(async message => {
                    let promise = message.delete();
                    socket.data.redis.del(`${messageCachePrefix}/${message._id}`);
                    const conversationMessageCacheKey = `${conversationRecentMessagesCachePrefix}/${message.conversation}`;
                    socket.data.redis.lrem(conversationMessageCacheKey, 0, JSON.stringify(message));
                    await promise;
                    socket.broadcast.to(message.conversation.toString()).emit(`messageDeleted:${message._id}`);
                });
                const conversations = await conversationModel.find({ participants: user._id });
                conversations.forEach(async conversation => {
                    const index = conversation.participants.indexOf(user._id);
                    conversation.participants.splice(index, 1);
                    let promise = conversation.save();
                    const conversationCacheKey = `${conversationCachePrefix}/${conversation._id}`;
                    socket.data.redis.set(conversationCacheKey, JSON.stringify(conversation));
                    socket.data.redis.expire(conversationCacheKey, 60 * 60 * conversationCacheHours);
                    await promise;
                    socket.broadcast.to(conversation._id.toString()).emit('userDeleted', { id: user._id });
                });
                const userCacheKey = `${userCachePrefix}/${user._id}`;
                socket.data.redis.del(userCacheKey);
                socket.broadcast.to(`userListener:${user._id}`).emit('userDeleted', {});
            } else {
                socket.emit('error', 'You are not authenticated.');
            }
        } catch (error) {
            socket.emit('error', error);
        }
    });
}