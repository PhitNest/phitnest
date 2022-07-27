const joi = require('joi');
const objectId = require('joi-objectid')(joi);
const { messageCachePrefix } = require('../../../constants');
const { getConversation, getMessage } = require('../helpers');

function validate(data) {
    const schema = joi.object({
        message: objectId().required(),
    });
    return schema.validate(data);
}

module.exports = socket => {
    socket.on('deleteMessage', async data => {
        const { error } = validate(data);
        if (error) {
            socket.emit('error', error);
        } else {
            try {
                const message = await getMessage(data.message, socket);
                if (message) {
                    const conversation = await getConversation(message.conversation, socket);
                    if (conversation) {
                        const messageCacheKey = `${messageCachePrefix}/${message._id}`
                        await socket.data.redis.del(messageCacheKey);
                        await message.delete();
                        socket.broadcast.to(message.conversation).emit(`messageDeleted:${message._id}`);
                    } else {
                        socket.emit('error', 'No conversation found');
                    }
                } else {
                    socket.emit('error', 'No message found');
                }
            } catch (error) {
                socket.emit('error', error);
            }
        }
    });
}