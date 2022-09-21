const express = require('express');
const router = express.Router();
const gymController = require('../controllers/gym');
const { validateCreateGym, validateNearestGym } = require('../middleware/gym');
const { isAdminAuthenticated } = require('../middleware/auth');

router.post(
  '/create',
  [isAdminAuthenticated, validateCreateGym],
  gymController.createGym
);
router.get('/nearest', [validateNearestGym], gymController.nearestGym);
router.get('/list', [validateNearestGym], gymController.nearestGyms);
module.exports = router;
