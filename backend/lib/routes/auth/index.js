const express = require("express");
const router = express.Router();
const { validateLogin, validateRegister } = require("../../middleware/auth");
const authController = require("../../controllers/auth");

router.post("/auth/login", [validateLogin], authController.login);
router.post("/auth/register", [validateRegister], authController.register);

module.exports = router;
