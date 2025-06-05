const pool = require('../config/db');
const authenticateUser = require('../middlewares/auth'); // Middleware de autenticación
const { generateToken } = require('../middlewares/auth');
const loginUser = require('../controllers/userController')

// Función para crear un postq
const createPost = async (req, res) => {
    let {
        title,
        content,
        topics,
        parent_post,
        noticia_title,
        noticia_content,
        noticia_url,
        noticia_datetime,
        noticia_source
    } = req.body;
    // console.log(topics.toString())
    const id_user = req.user.id_user;
    const nation_user = req.user.nation;

    try {
        // Validar campos vacíos
        if (!title || title.trim() === "") title = null;
        if (!parent_post || parent_post.toString().trim() === "") parent_post = null;

        let noticia = null;

        if (noticia_title && noticia_title.trim() !== "") {
            const comprobacionNoticia = await pool.query(
                `SELECT * FROM noticia WHERE title = $1`,
                [noticia_title]
            );

            if (comprobacionNoticia.rows.length === 0) {
                const newNoticia = await pool.query(
                    `INSERT INTO noticia (source_name, title, content, link, fecha)
                     VALUES ($1, $2, $3, $4, $5) RETURNING *`,
                    [noticia_source, noticia_title, noticia_content, noticia_url, noticia_datetime]
                );
                noticia = newNoticia.rows[0].id_noticia;
                //console.log("Título de noticia insertado:", newNoticia.rows[0].title);
            } else {
                noticia = comprobacionNoticia.rows[0].id_noticia;
                //console.log("Título de noticia ya existe:", comprobacionNoticia.rows[0].title);
            }
        }

        const post_date = new Date();

        // Insertar el post principal
        const newPost = await pool.query(
            `INSERT INTO post (id_user, title, nation, content, post_date, parent_post, noticia)
             VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
            [id_user, title, nation_user, content, post_date, parent_post, noticia]
        );

        const id_post = newPost.rows[0].id_post;
        if (typeof topics === 'string') {
            topics = topics.split(',').map(t => t.trim()).filter(Boolean);
        }
        // Insertar temas en la tabla post_topic
    if (Array.isArray(topics) && topics.length > 0) {
        topics = topics.map(t => t.trim());
        const insertTopicQueries = topics.map(async topic => {
            // Verifica si el tema existe en la tabla topic
        const exists = await pool.query(
            `SELECT 1 FROM topic WHERE topic_name = $1`,
            [topic]
        );
        console.log(`Verificando tema: ${exists.rows.length > 0 ? topic : 'No existe'}`);
        if (exists.rows.length > 0) {
            console.log(`Tema insertado: ${topic}`);
            return pool.query(
                `INSERT INTO post_topic (id_post, topic_name) VALUES ($1, $2)`,
                [id_post, topic]
            );
        } else {
            console.warn(`El tema "${topic}" no existe en la tabla topic. No se insertó.`);
            return null;
        }
    });
    await Promise.all(insertTopicQueries);
}

        res.status(201).json({ message: 'Post creado exitosamente', post: newPost.rows[0] });

    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: 'Error al crear el post' });
    }
};



const getPost = async (req, res) => {
    const id_user = req.user.id_user;
    const nation_user = req.user.nation;
    const { nation, topic, post_dateIN, post_dateFI } = req.body;

    let query = `
        SELECT 
            POST.*,
            USERS.username AS user_name,
            NOTICIA.title AS noticia_title, 
            NOTICIA.content AS noticia_content, 
            NOTICIA.source_name AS noticia_source,
            NOTICIA.fecha AS noticia_fecha,
            NOTICIA.link AS noticia_link
        FROM POST
        INNER JOIN USERS ON POST.id_user = USERS.id_user
        LEFT JOIN NOTICIA ON POST.noticia = NOTICIA.id_noticia
        WHERE POST.parent_post is null
    `;

    const conditions = []
    let values = [];
    let index = 1;

    // Construcción dinámica de las condiciones
    if (nation && nation.trim() !== "") {
        conditions.push(`POST.nation = $${index++}`);
        values.push(nation);
    }
    /*  else{
            conditions.push(`POST.nation = $${index++}`);
            values.push(nation_user);
        }*/
    if (topic && topic.trim() !== "") {
        conditions.push(`POST.topic = $${index++}`);
        values.push(topic);
    }
    if (post_dateIN && post_dateIN.trim() !== "") {
        if (post_dateFI && post_dateFI.trim() !== "") {
            conditions.push(`POST.post_date BETWEEN $${index++} AND $${index++}`);
            values.push(post_dateIN, post_dateFI);
        } else {
            conditions.push(`POST.post_date = $${index++}`);
            values.push(post_dateIN);
        }
    }

    // Si hay condiciones, las añadimos a la consulta
    if (conditions.length > 0) {
        query += ` AND ${conditions.join(' AND ')}`;
    }

    query += ' ORDER BY POST.post_date DESC;';
    const queryUser = 'SELECT * FROM users WHERE id_user = $1';
    const resultUser = await pool.query(queryUser, [id_user])
    const user = resultUser.rows[0];

    try {
        const token = generateToken(user)
        const result = await pool.query(query, values);
        res.status(200).json({
            message: 'Post extraídos correctamente',
            data: result.rows,
            token
        });

    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: 'Error al obtener posts' });
    }
};

const getFollowedPosts = async (req, res) => {
    const id_user = req.user.id_user;

    try {
        // Obtener IDs de usuarios seguidos
        const followersResult = await pool.query(
            `SELECT id_followed FROM following WHERE id_follower = $1`,
            [id_user]
        );

        const followedIds = followersResult.rows.map(row => row.id_followed);

        if (followedIds.length === 0) {
            // No sigue a nadie, devolver array vacío
            return res.status(666).json({ data: [] });
        }

        // Consulta usando ANY para array
        const postsResult = await pool.query(
            `SELECT POST.*, USERS.username AS user_name,
            NOTICIA.title AS noticia_title, 
            NOTICIA.content AS noticia_content, 
            NOTICIA.source_name AS noticia_source,
            NOTICIA.fecha AS noticia_fecha,
            NOTICIA.link AS noticia_link
            FROM POST INNER JOIN USERS ON POST.id_user = USERS.id_user
            LEFT JOIN NOTICIA ON POST.noticia = NOTICIA.id_noticia 
            WHERE USERS.id_user = ANY($1::int[]) AND POST.parent_post is null
            ORDER BY POST.post_date DESC`,
            [followedIds]
        );

        res.status(200).json({ data: postsResult.rows });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al obtener posts' });
    }
}

const getComments = async (req, res) => {
    const id_post = req.body.id_post;

    const query = `SELECT POST.*, USERS.username AS user_name FROM POST INNER JOIN 
                        USERS ON POST.id_user = USERS.id_user WHERE POST.parent_post = $1`;

    try {
        const resultado = await pool.query(query, [id_post]);
        res.status(200).json({
            message: 'Comentarios extraídos correctamente',
            data: resultado.rows,
        });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: 'Error al obtener los comentarios de este post' })
    }
};

const getParentPost = async (req, res) => {
    let id_child = req.body.id_post;
    let queryParentPost = `SELECT parent_post FROM POST WHERE id_post = $1`;
    //let parent_post = null;
    while (true) {
        const result = await pool.query(queryParentPost, [id_child]);
        if (result.rows[0].parent_post == null) {
            // parent_post = result.rows[0].parent_post;
            break
        } else {
            id_child = result.rows[0].parent_post;
        }
    }
    const queryPost = `SELECT 
            POST.*,
            USERS.username AS user_name,
            NOTICIA.title AS noticia_title, 
            NOTICIA.content AS noticia_content, 
            NOTICIA.source_name AS noticia_source,
            NOTICIA.fecha AS noticia_fecha,
            NOTICIA.link AS noticia_link
        FROM POST
        INNER JOIN USERS ON POST.id_user = USERS.id_user
        LEFT JOIN NOTICIA ON POST.noticia = NOTICIA.id_noticia
        WHERE POST.id_post = $1`;
    const resultPost = await pool.query(queryPost, [id_child])
    console.log(resultPost.rows[0].id_post);
    res.status(200).json({
        message: 'Post padre obtenido correctamente',
        data: resultPost.rows[0],
    })
}

const savePost = async (req, res) => {
    const { id_post } = req.body;
    const id_user = req.user.id_user;

    try {
        // Verificar si el post ya está guardado
        const checkPost = await pool.query(
            `SELECT * FROM saved_post WHERE id_user = $1 AND id_post = $2`,
            [id_user, id_post]
        );

        if (checkPost.rows.length > 0) {
            return res.status(666).json({ message: 'El post ya está guardado' });
        } else {
            await pool.query(
                `INSERT INTO saved_post (id_user, id_post) VALUES ($1, $2)`,
                [id_user, id_post]
            );
        }
        res.status(200).json({ message: 'Post guardado exitosamente' });

    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: 'Error al guardar el post' });
    }
}

const checkSaved = async (req, res) => {
    const { id_post } = req.body;
    const id_user = req.user.id_user;
    let saved = false
    try {
        // Verificar si el post está guardado
        const checkPost = await pool.query(
            `SELECT * FROM saved_post WHERE id_user = $1 AND id_post = $2`,
            [id_user, id_post]
        );

        if (checkPost.rows.length != 0) {
            saved = true;
            return res.status(200).json({
                message: 'El post está guardado',
                saved: saved
            });

        } else {
            return res.status(200).json({
                message: 'El post no está guardado',
                saved: saved
            });
        }

    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: 'Error al verificar el estado del post guardado' });
    }
}

const unSavePost = async (req, res) => {
    const { id_post } = req.body;
    const id_user = req.user.id_user;

    try {
        // Verificar si el post está guardado
        const checkPost = await pool.query(
            `SELECT * FROM saved_post WHERE id_user = $1 AND id_post = $2`,
            [id_user, id_post]
        );

        if (checkPost.rows.length === 0) {
            return res.status(200).json({ message: 'El post no está guardado' });
        }

        // Eliminar el post guardado
        await pool.query(
            `DELETE FROM saved_post WHERE id_user = $1 AND id_post = $2`,
            [id_user, id_post]
        );

        res.status(200).json({ message: 'Post eliminado de los guardados exitosamente' });

    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: 'Error al eliminar el post de los guardados' });
    }
}

const getPostsByTopic = async (req, res) => {
    let topics = req.body.topics; // Espera { "topics": ["tema1", "tema2"] }

    if (typeof topics === 'string') {
        topics = topics.split(',').map(t => t.trim()).filter(Boolean);
    }
    if (!Array.isArray(topics) || topics.length === 0) {
        return res.status(400).json({ message: 'Debes enviar al menos un topic' });
    }

    const query = `
    SELECT POST.*, 
        post_topic.topic_name AS topic_name,
        USERS.username AS user_name,
        NOTICIA.title AS noticia_title,
        NOTICIA.content AS noticia_content,
        NOTICIA.source_name AS noticia_source,
        NOTICIA.fecha AS noticia_fecha,
        NOTICIA.link AS noticia_link
        FROM POST
        INNER JOIN post_topic ON POST.id_post = post_topic.id_post
        LEFT JOIN NOTICIA ON POST.noticia = NOTICIA.id_noticia
        INNER JOIN USERS ON POST.id_user = USERS.id_user 
        WHERE post_topic.topic_name = ANY($1::text[])
        ORDER BY POST.post_date DESC
`;
    try {
        const resultado = await pool.query(query, [topics]);
        res.status(200).json({
            message: 'Posts extraídos correctamente',
            data: resultado.rows,
        });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: 'Error al obtener los posts por tema' });
    }
}


module.exports = { createPost, getPost, getComments, getFollowedPosts, getParentPost, savePost, checkSaved, unSavePost, getPostsByTopic };

