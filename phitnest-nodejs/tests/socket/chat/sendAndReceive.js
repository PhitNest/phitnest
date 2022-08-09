const {
  conversationCachePrefix,
  conversationRecentMessagesCachePrefix,
} = require('../../../lib/constants');

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

  let convoMessages = Array(3);

  test('Send message correctly', (done) => {
    let user0Convo2 = false;
    let user1Convo0 = false;
    let user1Convo1 = false;
    let user1Convo2 = false;
    let user2Convo2 = false;

    const checkDone = () => {
      if (
        user0Convo2 &&
        user1Convo0 &&
        user1Convo1 &&
        user1Convo2 &&
        user2Convo2
      ) {
        done();
      }
    };

    users[0].client.on('receiveMessage', (data) => {
      if (data.conversation == conversations[2]._id.toString()) {
        user0Convo2 = true;
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
      checkDone();
    });

    users[1].client.on('receiveMessage', (data) => {
      if (data.conversation == conversations[0]._id.toString()) {
        user1Convo0 = true;
        convoMessages[0] = [data._id];
        expect(data.sender).toBe(users[0]._id.toString());
      } else if (data.conversation == conversations[1]._id.toString()) {
        user1Convo1 = true;
        convoMessages[1] = [data._id];
        expect(data.sender).toBe(users[2]._id.toString());
      } else if (data.conversation == conversations[2]._id.toString()) {
        if (convoMessages[2]) {
          user1Convo2 = true;
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
      checkDone();
    });

    users[2].client.on('receiveMessage', (data) => {
      if (data.conversation == conversations[2]._id.toString()) {
        user2Convo2 = true;
        expect(data.sender).toBe(users[0]._id.toString());
      } else {
        fail(
          `User 2 should not receive message: ${data.message} from sender: ${data.sender}`
        );
      }
      checkDone();
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
};
