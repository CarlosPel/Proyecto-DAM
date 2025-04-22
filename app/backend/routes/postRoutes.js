const express = require('express');
const { authenticateUser } = require('../middlewares/auth.js');
const { createPost } = require('../controllers/postController.js');


const router = express.Router();

router.post('/create', authenticateUser, createPost);

module.exports = router;
