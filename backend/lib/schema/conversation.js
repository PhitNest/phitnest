const conversationsDomain = 'conversations';

function conversationsKey(conversationId) {
  return `${conversationsDomain}:${conversationId}`;
}

function conversationMessagesKey(conversationId) {
  return `${conversationsKey(conversationId)}:messages`;
}

function conversationParticipantsKey(conversationId) {
  return `${conversationsKey(conversationId)}:participants`;
}

export default (redis) => ({
  getFirstMessageIdsFromEachConversation: (conversationIds) =>
    Promise.all(
      conversationIds.map(
        (id) => redis.zrevrange(conversationMessagesKey(id), 0, 1)[0]
      )
    ),
  isMember: (conversationId, userId) =>
    redis.sismember(conversationParticipantsKey(conversationId), userId),
  getMessageIds: (conversationId, amount, start) =>
    redis.zrevrange(
      conversationMessagesKey(conversationId),
      start,
      amount > 0 ? start + amount : amount
    ),
});
