const express = require("express");
const router = express.Router();
const getPaths = require("../getPaths");

/* GET home page. */
router.post("/", async function (req, res, next) {
  const { params } = req;
  const kb = "nm0000102";
  const actor = "nm0000702";

  const paths = await getPaths(kb, actor, 'shortest');

  res.json({ paths });
});

module.exports = router;
