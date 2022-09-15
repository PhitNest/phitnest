const joi = require('joi');
const { maxListMessageLimit } = require('../../constants');

function validate(req) {
  const schema = joi.object({
    conversation: joi.string().required(),
    limit: joi.number().min(1).max(maxListMessageLimit).required(),
  });
  return schema.validate(req);
}

module.exports = async (req, res, next) => {
  const { error } = validate(req.query);
  if (error) {
    return res.status(400).send(error.details[0].message);
  }
  next();
};
