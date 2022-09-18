const express = require('express');
const router = express.Router();
const gymController = require('../controllers/gym');
const { validateCreateGym } = require('../middleware/gym');
const { isAdminAuthenticated } = require('../middleware/auth');

router.post(
  '/create',
  [isAdminAuthenticated, validateCreateGym],
  gymController.createGym
);
module.exports = router;
