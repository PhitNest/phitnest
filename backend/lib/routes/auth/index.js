const express = require("express");
const router = express.Router();
const { validateLogin, validateRegister } = require("../../middleware/auth");
const authController = require("../../controllers/auth");
const admin = require("./admin");

router.post("/auth/login", [validateLogin], authController.login);
router.post("/auth/register", [validateRegister], authController.register);
router.use("/auth/admin", admin);

module.exports = router;
