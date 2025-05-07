// Fichero server.js

// Importar funciones y frameworks/librerías.
const express = require('express');
const cors = require('cors');
const userRoutes = require('./routes/userRoutes');
const postRoutes = require('./routes/postRoutes');
const newsRoutes = require('./routes/newsRoutes');
require('dotenv').config();

// Inicializa Express
const app = express();

// Define el puerto den el que se levantará el servidor
const PORT = process.env.SERVER_PORT || 5000;

// Configura que el backend pueda recibir peticiones con json como body
app.use(express.json({ type: 'application/json', charset: 'utf-8' }));

// Habilita que el backend pueda recibir peticiones desde diferentes dominios.
app.use(cors());

// Configuración de las rutas que han de seguir las peticiones HTTP
app.use('/users', userRoutes);
app.use('/posts', postRoutes);
app.use('/news', newsRoutes);

// Puerto en el que está levantado el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
