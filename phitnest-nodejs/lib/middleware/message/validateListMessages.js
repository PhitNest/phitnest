const joi = require('joi');
const objectId = require('joi-objectid')(joi);

function validate(req) {
  const schema = joi.object({
    conversation: objectId().required(),
    limit: joi.number().required(),
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
