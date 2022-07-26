const CACHE_HOURS = 0.05;

module.exports = async (req, res, next) => {
    const userInfo = await res.locals.redis.get(`userData/${res.locals.uid}`);
    if (userInfo) {
        console.log('used cache');
        res.locals.redis.expire(`userData/${res.locals.uid}`, 60 * 60 * CACHE_HOURS);
        return res.status(200).json(JSON.parse(userInfo));
    } else {
        next();
    }
}