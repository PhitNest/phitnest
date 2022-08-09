const { userModel } = require('../../models');
const { userCacheHours, userCachePrefix } = require('../../constants');

module.exports = async (req, res) => {
  try {
    const user = await userModel.findById(res.locals.userId);
    if (user) {
      await res.locals.redis.setex(
        `${userCachePrefix}/${res.locals.userId}`,
        60 * 60 * userCacheHours,
        JSON.stringify(user)
      );
      return res.status(200).json(user);
    }
  } catch (error) {
    return res.status(500).send(error.message);
  }
};
