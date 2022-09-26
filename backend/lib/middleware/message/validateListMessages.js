const joi = require('joi');
const { StatusBadRequest } = require('../../constants');
joi.objectId = require('joi-objectid')(joi);

function validate(req) {
  const schema = joi.object({
    conversation: joi.objectId().required(),
    start: joi.number().integer().min(-1).optional(),
    limit: joi.number().integer().min(-1).optional(),
  });
  return schema.validate(req);
}

module.exports = async (req, res, next) => {
  const { error } = validate(req.query);
  if (error) {
    return res.status(StatusBadRequest).send(error.details[0].message);
  }
  next();
};
