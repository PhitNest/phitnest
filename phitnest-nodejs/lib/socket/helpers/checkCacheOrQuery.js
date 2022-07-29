module.exports = async (redis, cachePrefix, cacheHours, model, modelId) => {
  const key = `${cachePrefix}/${modelId}`;
  const cache = await redis.get(key);
  let result;
  if (cache) {
    result = model.hydrate(JSON.parse(cache));
  } else {
    result = await model.findById(modelId);
  }
  if (result) {
    await redis.setex(key, 60 * 60 * cacheHours, JSON.stringify(result));
  }
  return result;
};
