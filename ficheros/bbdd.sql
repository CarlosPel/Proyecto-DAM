-- Creación de la base de datos
\c postgres
DROP DATABASE agora;

CREATE DATABASE agora;
\c agora; 


-- Creación de la tabla nation
CREATE TABLE nation (
    code INT PRIMARY KEY,
    nation_name VARCHAR (100) UNIQUE NOT NULL
);

-- Creación de la tabla user
CREATE TABLE users (
    id_user SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    nation INT NOT NULL,
    admin BOOLEAN DEFAULT false,
    FOREIGN KEY (nation) REFERENCES nation(code) ON DELETE SET NULL ON UPDATE CASCADE
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
    topic_name VARCHAR(100) UNIQUE NOT NULL PRIMARY KEY
);

-- Creación de la tabla user_topic
CREATE TABLE user_topic (
    id_user INT,
    topic_name VARCHAR(100),
    PRIMARY KEY (id_user, topic_name),
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    FOREIGN KEY (topic_name) REFERENCES topic(topic_name) ON DELETE CASCADE
);

-- Creación de la tabla post
CREATE TABLE post (
    id_post SERIAL PRIMARY KEY,
    id_user INT NOT NULL,
    title VARCHAR(100),
    nation INT NOT NULL,
    topic VARCHAR(100),
    content TEXT NOT NULL,
    post_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    parent_post INT NULL,
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    FOREIGN KEY (nation) REFERENCES nation(code) ON DELETE SET NULL,
    FOREIGN KEY (topic) REFERENCES topic(topic_name) ON DELETE SET NULL,
    FOREIGN KEY (parent_post) REFERENCES post(id_post) ON DELETE CASCADE
);

-- Creación de la tabla noticia
CREATE TABLE noticia (
    id_noticia SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    author_name VARCHAR(200) NOT NULL,
    content TEXT NOT NULL
);

-- Insert de las naciones
INSERT INTO nation (code, nation_name) VALUES 
(34, 'Spain');
