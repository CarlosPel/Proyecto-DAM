// server.js
require('dotenv').config();
const express = require('express');
const authRoutes = require('./routes/authRoutes');

const app = express();

// Middleware para parsear JSON
app.use(express.json());

// Rutas de autenticación
app.use('/api/auth', authRoutes);

// Puerto de escucha
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});

