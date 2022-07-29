const { userCacheHours, userCachePrefix } = require("../../constants");

module.exports = async (req, res, next) => {
  const userInfo = await res.locals.redis.get(
    `${userCachePrefix}/${res.locals.userId}`,
    { EX: 60 * 60 * userCacheHours }
  );
  if (userInfo) {
    return res.status(200).json(JSON.parse(userInfo));
  } else {
    next();
  }
};
