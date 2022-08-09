const { userModel } = require('../../models');

module.exports = async (req, res, next) => {
  const users = await userModel.aggregate([
    {
      $match: { $or: [{ email: req.body.email }, { mobile: req.body.mobile }] },
    },
  ]);
  if (users.length > 0) {
    let emailTaken = false;
    let mobileTaken = false;
    for (let i = 0; i < users.length; i++) {
      if (users[i].email == req.body.email) {
        emailTaken = true;
      } else {
        mobileTaken = true;
      }
    }
    let message = '';
    if (emailTaken && mobileTaken) {
      message = 'A user exists with both this email and mobile.';
    } else if (emailTaken) {
      message = 'A user already exists with this email.';
    } else {
      message = 'A user already exists with this mobile.';
    }
    return res.status(500).send(message);
  } else {
    next();
  }
};
