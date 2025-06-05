//º Importar funciones y frameworks/librerías.
const express = require('express');
const { authenticateUser } = require('../middlewares/auth.js');
const { createPost, getPost, getComments, getFollowedPosts, getParentPost, savePost } = require('../controllers/postController.js');

// Creamos un enrutador para manejar rutas de manera modular, fuera del fichero server.js
const router = express.Router();

// Rutas para el controlador de publicaciones (posts)
router.post('/create', authenticateUser, createPost);
router.post('/get', authenticateUser, getPost);
router.post('/comments', getComments);
router.post('/getfollowed', authenticateUser, getFollowedPosts);
router.post('/parentpost', getParentPost);
router.post('/save', authenticateUser, savePost);

// Exportamos el enrutador para ser utilizado en otros ficheros.
module.exports = router;
