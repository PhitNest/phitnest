const messagesDomain = 'messages';

const messagesCountKey = `${messagesDomain}:count`;

function getMessageKey(messageId) {
  return `${messagesDomain}${messageId}`;
}

module.exports = (redis) => ({
  getMessagesByIds: (ids) =>
    Promise.all(
      ids.map(async (id, index) => {
        const key = getMessageKey(id);
        const [sender, text, conversation] = await redis
          .multi()
          .hget(key, 'sender')
          .hget(key, 'text')
          .hget(key, 'conversation')
          .exec();
        return {
          id: id,
          conversation: conversation[1],
          sender: sender[1],
          text: text[1],
        };
      })
    ),
});
