module.exports = async (req, res) => {
  const key = `users:${res.locals.userId}`;
  const [firstName, lastName, email] = await res.locals.redis
    .multi()
    .hget(key, 'firstName')
    .hget(key, 'lastName')
    .hget(key, 'email')
    .exec();
  return {
    firstName: firstName,
    lastName: lastName,
    email: email,
  };
};
