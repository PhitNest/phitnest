const {
  conversationCachePrefix,
  conversationRecentMessagesCachePrefix,
  messageCachePrefix
} = require('../../../lib/constants');
const Q = require('q');

module.exports = () => {
  const users = globalThis.data.users;
  const conversations = globalThis.data.conversations;

  test('Send message without conversation', (done) => {
    users[0].client.on('error', (data) => {
      done();
    });
    users[0].client.emit('sendMessage', { message: 'hello' });
  });

  test('Conversation cache should be empty', async () => {
    for (let i = 0; i < conversations.length; i++) {
      expect(
        await globalThis.redis.get(
          `${conversationCachePrefix}/${conversations[i]._id}`
        )
      ).toBe(null);
      expect((
        await globalThis.redis.zrange(
          `${conversationRecentMessagesCachePrefix}/${conversations[i]._id}`, 0, -1
        )).length
      ).toBe(0);
    }
  });

  test('Send message without text', (done) => {
    users[0].client.on('error', (data) => {
      done();
    });
    users[0].client.emit('sendMessage', {
      conversation: conversations[0]._id,
    });
  });

  test('Send message to a conversation you are not a part of', (done) => {
    users[0].client.on('error', (data) => {
      done();
    });
    users[0].client.emit('sendMessage', { conversation: conversations[1]._id, message: 'hello' });
  });

  let convoMessages = Array(3);

  test('Send message correctly', async () => {
    const user0Convo2 = Q.defer();
    const user1Convo0 = Q.defer();
    const user1Convo1 = Q.defer();
    const user1Convo2 = Q.defer();
    const user2Convo2 = Q.defer();

    users[0].client.on('receiveMessage', (data) => {
      if (data.conversation == conversations[2]._id.toString()) {
        user0Convo2.resolve();
        expect(data.sender).toBe(users[2]._id.toString());
        users[0].client.emit('sendMessage', {
          conversation: conversations[2]._id,
          message: 'Second message',
        });
      } else {
        fail(
          `User 0 should not receive message: ${data.message} from sender: ${data.sender}`
        );
      }
    });

    users[1].client.on('receiveMessage', (data) => {
      if (data.conversation == conversations[0]._id.toString()) {
        user1Convo0.resolve();
        convoMessages[0] = [data._id];
        expect(data.sender).toBe(users[0]._id.toString());
      } else if (data.conversation == conversations[1]._id.toString()) {
        user1Convo1.resolve();
        convoMessages[1] = [data._id];
        expect(data.sender).toBe(users[2]._id.toString());
      } else if (data.conversation == conversations[2]._id.toString()) {
        if (convoMessages[2]) {
          user1Convo2.resolve();
          convoMessages[2].push(data._id);
          expect(data.sender).toBe(users[0]._id.toString());
        } else {
          convoMessages[2] = [data._id];
          expect(data.sender).toBe(users[2]._id.toString());
        }
      } else {
        fail(
          `User 1 should not receive message: ${data.message} from sender: ${data.sender}`
        );
      }
    });

    users[2].client.on('receiveMessage', (data) => {
      if (data.conversation == conversations[2]._id.toString()) {
        user2Convo2.resolve();
        expect(data.sender).toBe(users[0]._id.toString());
      } else {
        fail(
          `User 2 should not receive message: ${data.message} from sender: ${data.sender}`
        );
      }
    });

    users[0].client.emit('sendMessage', {
      conversation: conversations[0]._id,
      message: 'hello',
    });

    users[2].client.emit('sendMessage', {
      conversation: conversations[1]._id,
      message: 'Hello my friend',
    });

    users[2].client.emit('sendMessage', {
      conversation: conversations[2]._id,
      message: 'Hello group chat',
    });

    await Promise.all([user0Convo2, user1Convo0, user1Convo1, user1Convo2, user2Convo2].map((deferred) => deferred.promise));
  });

  test('Conversations should be cached', async () => {
    for (let i = 0; i < conversations.length; i++) {
      expect(
        JSON.parse(
          await globalThis.redis.get(
            `${conversationCachePrefix}/${conversations[i]._id}`
          )
        )._id
      ).toBe(conversations[i]._id.toString());

      (
        await globalThis.redis.zrange(
          `${conversationRecentMessagesCachePrefix}/${conversations[i]._id}`,
          0,
          -1
        )
      )
        .map((message) => JSON.parse(message)._id)
        .forEach((id, index) => {
          expect(id).toBe(convoMessages[i][index]);
        });
    }
  });

  test('Messages should be cached', async () => {
    for (let i = 0; i < convoMessages.length; i++) {
      for (let j = 0; j < convoMessages[i].length; j++) {
        expect(JSON.parse(await globalThis.redis.get(`${messageCachePrefix}/${convoMessages[i][j]}`))._id).toBe(convoMessages[i][j]);
      }
    }
  });
};
