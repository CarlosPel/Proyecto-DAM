const express = require('express');
const { authenticateUser } = require('../middlewares/auth.js');
const { createPost, getPost, getComments } = require('../controllers/postController.js');


const router = express.Router();

router.post('/create', authenticateUser, createPost);
router.post('/get', authenticateUser, getPost);
router.post('/comments', getComments)

module.exports = router;
