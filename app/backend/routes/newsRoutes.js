// Importar funciones y frameworks/librerías.
const express = require('express');
const { getNews } = require('../controllers/newsController.js');

// Creamos un enrutador para manejar rutas de manera modular, fuera del fichero server.js
const router = express.Router();

// Rutas para el controlador de noticias (news)
router.post('/get', getNews);

// Exportamos el enrutador para ser utilizado en otros ficheros.
module.exports = router;
