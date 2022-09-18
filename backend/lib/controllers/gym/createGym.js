module.exports = async (req, res) => {
  const { createGym } = require('../../schema/gym')(res.locals.redis);
};
