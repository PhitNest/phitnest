const usersDomain = 'users';

const usersCountKey = `${usersDomain}:count`;

function userKey(userId) {
  return `${usersDomain}:${userId}`;
}

const userEmailsDomain = `${usersDomain}:emails`;

function userEmailKey(email) {
  return `${userEmailsDomain}:${email}`;
}

function userConversationsKey(userId) {
  return `${userKey(userId)}:conversations`;
}

async function getUserCount(redis) {
  return (await redis.get(usersCountKey)) ?? '0';
}

module.exports = (redis) => ({
  getConversationIds: (userId) =>
    redis.zrevrange(userConversationsKey(userId), 0, -1),
  getIdAndPasswordFromEmail: async (email) => {
    const [password, id] = await redis
      .multi()
      .hget(userEmailKey(email), 'password')
      .hget(userEmailKey(email), 'id')
      .exec();
    return {
      password: password[1],
      id: id[1],
    };
  },
  createUser: async ({ email, password, firstName, lastName }) => {
    const id = await getUserCount(redis);
    await redis
      .multi()
      .hset(userKey(id), {
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      })
      .hset(userEmailKey(email), {
        id: id,
        password: password,
      })
      .incr(usersCountKey)
      .exec();
    return id;
  },
});
