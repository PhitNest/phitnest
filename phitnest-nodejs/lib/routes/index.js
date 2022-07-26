const express = require('express');
const router = express.Router();
const user = require('./user');
const auth = require('./auth');

const { isAuthenticated } = require('../middleware/auth');

router.use('/user', [isAuthenticated], user);
router.use('/auth', auth);

module.exports = router;