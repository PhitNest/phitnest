const joi = require('joi');
const { StatusBadRequest } = require('../../constants');

function validate(req) {
  const schema = joi.object({
    longitude: joi.number().min(-180).max(180).required(),
    latitude: joi.number().min(-90).max(90).required(),
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
