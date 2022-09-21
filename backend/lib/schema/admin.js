const adminsDomain = 'admins';

const adminsCountKey = `${adminsDomain}:count`;

function adminKey(adminId) {
  return `${adminsDomain}:${adminId}`;
}

const adminEmailsDomain = `${adminsDomain}:emails`;

function adminEmailKey(email) {
  return `${adminEmailsDomain}:${email}`;
}

async function getAdminCount(redis) {
  return (await redis.get(adminsCountKey)) ?? '0';
}

module.exports = (redis) => ({
  getAdminIdAndPasswordFromEmail: async (email) => {
    const [password, id] = await redis
      .multi()
      .hget(adminEmailKey(email), 'password')
      .hget(adminEmailKey(email), 'id')
      .exec();
    return {
      password: password[1],
      id: id[1],
    };
  },
  createAdmin: async ({ email, password, firstName, lastName }) => {
    const id = await getAdminCount(redis);
    await redis
      .multi()
      .hset(adminKey(id), {
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      })
      .hset(adminEmailKey(email), {
        id: id,
        password: password,
      })
      .incr(adminsCountKey)
      .exec();
    return id;
  },
});
