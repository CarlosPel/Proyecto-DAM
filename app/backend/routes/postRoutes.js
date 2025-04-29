const express = require('express');
const { authenticateUser } = require('../middlewares/auth.js');
const { createPost, getPost } = require('../controllers/postController.js');


const router = express.Router();

router.post('/create', authenticateUser, createPost);
router.post('/get', authenticateUser, getPost);

module.exports = router;
