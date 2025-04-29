const { Pool } = require('pg');
require('dotenv').config(); // Carga las variables de entorno del archivo .env

// Configuración de la conexión
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
  client_encoding: 'UTF8',
});

pool.on('connect', (client) => {
  client.query('SET client_encoding = "UTF8";')
    .then(() => console.log('Codificación del cliente establecida en UTF-8'))
    .catch((err) => console.error('Error al configurar client_encoding:', err));
});

pool.on('connect', () => {
  console.log('Conectado a la base de datos PostgreSQL');
});

module.exports = pool;