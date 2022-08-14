const supertest = require('supertest');
const {
    conversationCachePrefix,
    conversationRecentMessagesCachePrefix,
    messageCachePrefix
} = require('../../../lib/constants');

module.exports = () => {
    const users = globalThis.data.users;
    const conversations = globalThis.data.conversations;

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

    test('Tried to list messages for a conversation you are not part of', () =>
        supertest(globalThis.app).get(`/message/list?conversation=${conversations[0]._id}&limit=${1}`).set('Authorization', users[2].jwt).expect(404)
    );

    test('Conversations should have no messages and should not use cache', async () => {
        for (let i = 0; i < conversations.length; i++) {
            await supertest(globalThis.app).get(`/message/list?conversation=${conversations[i]._id}&limit=${1}`).set('Authorization', users.find((user) => user._id == conversations[i].participants[0]).jwt).expect(200).then(data => {
                expect(data.body.length).toBe(1);
                expect(data.header.usedcache).toBe("false");
            });
        }
    });
}