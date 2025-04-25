const pool = require('../config/db');
const http = require('https');

const getNews = async (req, res) => {
    try {
        const { urlFi } = req.body; // Recibe la terminación de la URL desde el frontend.

        // Configura los detalles de la solicitud.
        const options = {
            method: 'GET',
            hostname: 'real-time-news-data.p.rapidapi.com',
            port: null,
            path: `${urlFi}`, // Añade la terminación proporcionada.
            headers: {
                'x-rapidapi-key': process.env.NEWS_API_RAPIDAPI_KEY, 
                'x-rapidapi-host': 'real-time-news-data.p.rapidapi.com',
            },
        };

        // Realiza la solicitud HTTPS.
        const rapidApiReq = http.request(options, (response) => {
            let chunks = [];

            // Recoge los datos.
            response.on('data', (chunk) => {
                chunks.push(chunk);
            });

            // Cuando finaliza la respuesta, convierte y envía los datos al frontend.
            response.on('end', () => {
                const body = Buffer.concat(chunks);
                const data = JSON.parse(body.toString());
                res.json(data); // Respuesta al frontend.
            });
        });

        // Manejo de errores en la solicitud.
        rapidApiReq.on('error', (error) => {
            res.status(500).json({ error: 'Error al realizar la solicitud a RapidAPI' });
        });

        rapidApiReq.end(); // Finaliza la solicitud.
    } catch (error) {
        // Manejo de errores generales.
        res.status(500).json({ error: `Error en la solicitud a RapidAPI: ${error.message}` });
    }
};

module.exports = { getNews };

/*
const getNews = async (req, res) => {
    try {
        const { urlFi } = req.body; // Recibe la terminación de la URL desde el frontend.



        // Construye la URL completa.
    // MEDIASTAK
    const apiKey = process.env.NEWS_API_MEDIASTAK_KEY;
        const baseUrl = `http://api.mediastack.com/v1/news?access_key=${apiKey}`;
        const fullUrl = `${baseUrl}${urlFi}`;


        // Llama a la API con la URL completa.
        const response = await fetch(fullUrl);
        const data = await response.json();

        if (response.ok) {
            res.json(data); // Devuelve los datos al frontend.
        } else {
            res.status(response.status).json({ error: data.message });
        }
    } catch (error) {
        // Manejo de errores generales.
        res.status(500).json({ error: 'Error al realizar la solicitud' });
    }
};

module.exports = { getNews };

*/