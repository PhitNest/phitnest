const express = require('express');
const router = express.Router();
const gymController = require('../controllers/gym');
const { validateCreateGym } = require('../middleware/gym');

router.post([validateCreateGym], gymController.createGym);
module.exports = router;
