module.exports = async (redis, cachePrefix, cacheHours, model, modelId) => {
    const key = `${cachePrefix}/${modelId}`;
    const cache = await redis.get(key);
    let result = null;
    if (cache) {
        result = model.hydrate(JSON.parse(cache));
    } else {
        result = await model.findById(modelId);
    }
    if (result) {
        redis.set(key, JSON.stringify(result));
        redis.expire(key, 60 * 60 * cacheHours);
    }
    return result;
}