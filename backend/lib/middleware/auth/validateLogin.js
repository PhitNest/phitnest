const {
  minPasswordLength,
  maxPasswordLength,
  minEmailLength,
  maxEmailLength,
  StatusBadRequest,
} = require('../../constants');
const joi = require('joi');

function validate(req) {
  const schema = joi.object({
    email: joi
      .string()
      .trim()
      .email()
      .min(minEmailLength)
      .max(maxEmailLength)
      .required(),
    password: joi
      .string()
      .min(minPasswordLength)
      .max(maxPasswordLength)
      .required(),
  });
  return schema.validate(req);
}

module.exports = async (req, res, next) => {
  const { error } = validate(req.body);
  if (error) {
    return res.status(StatusBadRequest).send(error.details[0].message);
  }
  next();
};
