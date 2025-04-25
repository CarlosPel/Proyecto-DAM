const express = require('express');
const { getNews } = require('../controllers/newsController.js');

const router = express.Router();

router.post('/get', getNews);

module.exports = router;
