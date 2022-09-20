const joi = require('joi');
const { StatusBadRequest } = require('../../constants');

function validate(req) {
  const schema = joi.object({
    name: joi.string().required(),
    address: joi.object({
      streetAddress: joi.string().required(),
      city: joi.string().required(),
      state: joi.string().required(),
      zipCode: joi.string().required(),
    }),
  });
  return schema.validate(req);
}

module.exports = async (req, res, next) => {
  const { error } = validate(req.body);
  if (req.body == undefined) {
    return res.status(StatusBadRequest).send('Please provide a body');
  }
  if (error) {
    return res.status(StatusBadRequest).send(error.details[0].message);
  }
  next();
};
