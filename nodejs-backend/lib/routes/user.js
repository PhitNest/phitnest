const express = require('express');
const router = express.Router();
const userController = require('../controllers/user');

router.get(userController.privateInfo);
module.exports = router;
