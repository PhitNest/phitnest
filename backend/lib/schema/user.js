const usersDomain = 'users';

const usersCountKey = `${usersDomain}:count`;

function userKey(userId) {
  return `${usersDomain}:${userId}`;
}

const userEmailsDomain = `${usersDomain}:emails`;

function userEmailKey(email) {
  return `${userEmailsDomain}:${email};`;
}

function userConversationsKey(userId) {
  return `${userKey(userId)}:conversations`;
}

export default (redis) => ({
  getConversationIds: (userId) =>
    redis.zrevrange(userConversationsKey(userId), 0, -1),
  getUserCount: () => redis.get(usersCountKey),
  getIdAndPasswordFromEmail: async (email) => {
    let [password, id] = await redis
      .multi()
      .hget(userEmailKey(email), 'password')
      .hget(userEmailKey(email), 'id')
      .exec();
    return {
      password: password,
      id: id,
    };
  },
  createUser: (id, email, hashedPassword, firstName, lastName) =>
    redis
      .multi()
      .hset(userKey(id), {
        email: email,
        password: hashedPassword,
        firstName: firstName,
        lastName: lastName,
      })
      .hset(userEmailKey(email), {
        id: id,
        password: hashedPassword,
      })
      .incr(usersCountKey)
      .exec(),
});
