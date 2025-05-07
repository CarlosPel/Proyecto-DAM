// Importamos el módulo pg de PostgreSQL
const { Pool } = require('pg');
// Cargamos las variables del fichero .env
require('dotenv').config(); 

// Configuración de la conexión
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
  client_encoding: 'UTF8',
});

// Ejecutamos la conexión
pool.on('connect', (client) => {
  client.query('SET client_encoding = "UTF8";')
    .then(() => console.log('Codificación del cliente establecida en UTF-8'))
    .catch((err) => console.error('Error al configurar client_encoding:', err));
});

// Mostramos que la conexión ha sido exitosa
pool.on('connect', () => {
  console.log('Conectado a la base de datos PostgreSQL');
});

module.exports = pool;