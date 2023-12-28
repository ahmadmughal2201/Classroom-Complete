const express = require("express");
const router = express.Router();
const classController = require("./../controllers/classController");


router.post("/createClass", classController.createClass);
router.post("/joinClass", classController.enrollStudent);
router.get("/getClasses/:email", classController.getAllClassesForUser);

module.exports = router;