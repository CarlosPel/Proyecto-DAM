const express = require('express');
const cors = require('cors');
const userRoutes = require('./routes/userRoutes');
const postRoutes = require('./routes/postRoutes');
const newsRoutes = require('./routes/newsRoutes');
require('dotenv').config();

const app = express();
const PORT = process.env.SERVER_PORT || 5000;

app.use(express.json({ type: 'application/json', charset: 'utf-8' }));// Middleware para parsear JSON

app.use(cors());

// Rutas
app.use('/users', userRoutes);
app.use('/posts', postRoutes);
app.use('/news', newsRoutes);

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
