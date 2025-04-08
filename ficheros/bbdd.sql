-- Creación de la base de datos (opcional)
CREATE DATABASE agora;
\c agora; 
-- Conectar a la base de datos (solo en PostgreSQL)

-- Creación de la tabla nation
CREATE TABLE nation (
    nationName VARCHAR(100) UNIQUE NOT NULL PRIMARY KEY
);

-- Creación de la tabla user
CREATE TABLE users (
    id_user SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    nation VARCHAR(100) NOT NULL,
    admin BOOLEAN DEFAULT false,
    FOREIGN KEY (nation) REFERENCES nation(nationName) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Creación de la tabla following
CREATE TABLE following (
    id_follower INT,
    id_followed INT,
    fecha_seguimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_follower, id_followed),
    FOREIGN KEY (id_follower) REFERENCES users(id_user) ON DELETE CASCADE,
    FOREIGN KEY (id_followed) REFERENCES users(id_user) ON DELETE CASCADE
);

-- Creación de la tabla topic
CREATE TABLE topic (
    topicName VARCHAR(100) UNIQUE NOT NULL PRIMARY KEY
);

-- Creación de la tabla user_topic
CREATE TABLE user_topic (
    id_user INT,
    topicName VARCHAR(100),
    PRIMARY KEY (id_user, topicName),
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    FOREIGN KEY (topicName) REFERENCES topic(topicName) ON DELETE CASCADE
);

-- Creación de la tabla post
CREATE TABLE post (
    id_post SERIAL PRIMARY KEY,
    id_user INT NOT NULL,
    title VARCHAR(100),
    nation VARCHAR(100) NOT NULL,
    topic VARCHAR(100),
    content TEXT NOT NULL,
    post_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    parent_post INT NULL,
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    FOREIGN KEY (nation) REFERENCES nation(nationName) ON DELETE SET NULL,
    FOREIGN KEY (topic) REFERENCES topic(topicName) ON DELETE SET NULL,
    FOREIGN KEY (parent_post) REFERENCES post(id_post) ON DELETE CASCADE
);

-- Creación de la tabla noticia
CREATE TABLE noticia (
    id_noticia SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    author_name VARCHAR(200) NOT NULL,
    content TEXT NOT NULL
);

-- Insert de una nacion para el registro
INSERT INTO nation (nationName) VALUES ('España');
