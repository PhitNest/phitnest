const {
  minLastNameLength,
  maxLastNameLength,
  minFirstNameLength,
  maxFirstNameLength,
  minPasswordLength,
  maxPasswordLength,
  minEmailLength,
  maxEmailLength,
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
    firstName: joi
      .string()
      .trim()
      .min(minFirstNameLength)
      .max(maxFirstNameLength)
      .required(),
    lastName: joi
      .string()
      .trim()
      .min(minLastNameLength)
      .max(maxLastNameLength)
      .optional(),
  });
  return schema.validate(req);
}

module.exports = async (req, res, next) => {
  const { error } = validate(req.body);
  if (error) {
    return res.status(400).send(error.details[0].message);
  }
  next();
};
