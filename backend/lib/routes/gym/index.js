const express = require("express");
const router = express.Router();
const gymController = require("../../controllers/gym");
const {
  validateCreateGym,
  validateNearestGym,
} = require("../../middleware/gym");
const { isAdminAuthenticated } = require("../../middleware/auth");

router.post(
  "/gym",
  [isAdminAuthenticated, validateCreateGym],
  gymController.createGym
);
router.get("/gym/nearest", [validateNearestGym], gymController.nearestGym);
router.get("/gym/list", [validateNearestGym], gymController.nearestGyms);

module.exports = router;
