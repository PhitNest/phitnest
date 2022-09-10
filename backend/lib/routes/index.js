const express = require('express');
const router = express.Router();
const user = require('./user');
const auth = require('./auth');
const message = require('./message');
const conversation = require('./conversation');

const { isAuthenticated } = require('../middleware/auth');

router.use('/user', [isAuthenticated], user);
router.use('/message', [isAuthenticated], message);
router.use('/conversation', [isAuthenticated], conversation);
router.use('/auth', auth);

module.exports = router;
