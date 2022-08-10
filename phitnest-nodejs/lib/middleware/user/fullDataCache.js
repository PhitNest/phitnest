const { userCacheHours, userCachePrefix } = require('../../constants');

module.exports = async (req, res, next) => {
  let userInfo = await res.locals.redis.getex(
    `${userCachePrefix}/${res.locals.userId}`,
    'EX',
    60 * 60 * userCacheHours
  );
  if (userInfo) {
    return res.status(200).append('usedcache', true).json(JSON.parse(userInfo));
  } else {
    res.append('usedcache', false);
    next();
  }
};
