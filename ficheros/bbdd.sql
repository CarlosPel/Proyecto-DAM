-- Creación de la base de datos
\c postgres
DROP DATABASE agora;

CREATE DATABASE agora;
\c agora; 


-- Creación de la tabla nation
CREATE TABLE nation (
    code VARCHAR(2) PRIMARY KEY,
    nation_name VARCHAR (100) UNIQUE NOT NULL
);

-- Creación de la tabla user
CREATE TABLE users (
    id_user SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    nation VARCHAR(2) NOT NULL,
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
    nation VARCHAR(2) NOT NULL,
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
('AF', 'Afghanistan'),
('AL', 'Albania'),
('DZ', 'Algeria'),
('AD', 'Andorra'),
('AO', 'Angola'),
('AR', 'Argentina'),
('AM', 'Armenia'),
('AU', 'Australia'),
('AT', 'Austria'),
('AZ', 'Azerbaijan'),
('BH', 'Bahrain'),
('BD', 'Bangladesh'),
('BY', 'Belarus'),
('BE', 'Belgium'),
('BZ', 'Belize'),
('BJ', 'Benin'),
('BT', 'Bhutan'),
('BO', 'Bolivia'),
('BA', 'Bosnia and Herzegovina'),
('BW', 'Botswana'),
('BR', 'Brazil'),
('BN', 'Brunei'),
('BG', 'Bulgaria'),
('BF', 'Burkina Faso'),
('BI', 'Burundi'),
('KH', 'Cambodia'),
('CM', 'Cameroon'),
('CA', 'Canada'),
('CV', 'Cape Verde'),
('CF', 'Central African Republic'),
('TD', 'Chad'),
('CL', 'Chile'),
('CN', 'China'),
('CO', 'Colombia'),
('KM', 'Comoros'),
('CG', 'Congo'),
('CK', 'Cook Islands'),
('CR', 'Costa Rica'),
('HR', 'Croatia'),
('CU', 'Cuba'),
('CY', 'Cyprus'),
('CZ', 'Czech Republic'),
('DK', 'Denmark'),
('DJ', 'Djibouti'),
('DM', 'Dominica'),
('DO', 'Dominican Republic'),
('EC', 'Ecuador'),
('EG', 'Egypt'),
('SV', 'El Salvador'),
('GQ', 'Equatorial Guinea'),
('ER', 'Eritrea'),
('EE', 'Estonia'),
('ET', 'Ethiopia'),
('FJ', 'Fiji'),
('FI', 'Finland'),
('FR', 'France'),
('GA', 'Gabon'),
('GM', 'Gambia'),
('GE', 'Georgia'),
('DE', 'Germany'),
('GH', 'Ghana'),
('GR', 'Greece'),
('GL', 'Greenland'),
('GD', 'Grenada'),
('GT', 'Guatemala'),
('GN', 'Guinea'),
('GW', 'Guinea-Bissau'),
('GY', 'Guyana'),
('HT', 'Haiti'),
('HN', 'Honduras'),
('HU', 'Hungary'),
('IS', 'Iceland'),
('IN', 'India'),
('ID', 'Indonesia'),
('IR', 'Iran'),
('IQ', 'Iraq'),
('IE', 'Ireland'),
('IL', 'Israel'),
('IT', 'Italy'),
('JM', 'Jamaica'),
('JP', 'Japan'),
('JO', 'Jordan'),
('KZ', 'Kazakhstan'),
('KE', 'Kenya'),
('KI', 'Kiribati'),
('KW', 'Kuwait'),
('KG', 'Kyrgyzstan'),
('LA', 'Laos'),
('LV', 'Latvia'),
('LB', 'Lebanon'),
('LS', 'Lesotho'),
('LR', 'Liberia'),
('LY', 'Libya'),
('LI', 'Liechtenstein'),
('LT', 'Lithuania'),
('LU', 'Luxembourg'),
('MG', 'Madagascar'),
('MW', 'Malawi'),
('MY', 'Malaysia'),
('MV', 'Maldives'),
('ML', 'Mali'),
('MT', 'Malta'),
('MH', 'Marshall Islands'),
('MR', 'Mauritania'),
('MU', 'Mauritius'),
('MX', 'Mexico'),
('FM', 'Micronesia'),
('MD', 'Moldova'),
('MC', 'Monaco'),
('MN', 'Mongolia'),
('ME', 'Montenegro'),
('MA', 'Morocco'),
('MZ', 'Mozambique'),
('MM', 'Myanmar'),
('NA', 'Namibia'),
('NR', 'Nauru'),
('NP', 'Nepal'),
('NL', 'Netherlands'),
('NZ', 'New Zealand'),
('NI', 'Nicaragua'),
('NE', 'Niger'),
('NG', 'Nigeria'),
('NO', 'Norway'),
('OM', 'Oman'),
('PK', 'Pakistan'),
('PW', 'Palau'),
('PS', 'Palestine'),
('PA', 'Panama'),
('PG', 'Papua New Guinea'),
('PY', 'Paraguay'),
('PE', 'Peru'),
('PH', 'Philippines'),
('PL', 'Poland'),
('PT', 'Portugal'),
('QA', 'Qatar'),
('RO', 'Romania'),
('RU', 'Russia'),
('RW', 'Rwanda'),
('WS', 'Samoa'),
('SM', 'San Marino'),
('ST', 'Sao Tome and Principe'),
('SA', 'Saudi Arabia'),
('SN', 'Senegal'),
('RS', 'Serbia'),
('SC', 'Seychelles'),
('SL', 'Sierra Leone'),
('SG', 'Singapore'),
('SK', 'Slovakia'),
('SI', 'Slovenia'),
('SB', 'Solomon Islands'),
('SO', 'Somalia'),
('ZA', 'South Africa'),
('KR', 'South Korea'),
('SS', 'South Sudan'),
('ES', 'Spain'),
('LK', 'Sri Lanka'),
('SD', 'Sudan'),
('SR', 'Suriname'),
('SZ', 'Eswatini'),
('SE', 'Sweden'),
('CH', 'Switzerland'),
('SY', 'Syria'),
('TW', 'Taiwan'),
('TJ', 'Tajikistan'),
('TZ', 'Tanzania'),
('TH', 'Thailand'),
('TG', 'Togo'),
('TO', 'Tonga'),
('TT', 'Trinidad and Tobago'),
('TN', 'Tunisia'),
('TR', 'Turkey'),
('TM', 'Turkmenistan'),
('TV', 'Tuvalu'),
('UG', 'Uganda'),
('UA', 'Ukraine'),
('AE', 'United Arab Emirates'),
('GB', 'United Kingdom'),
('US', 'United States'),
('UY', 'Uruguay'),
('UZ', 'Uzbekistan'),
('VU', 'Vanuatu'),
('VA', 'Vatican City'),
('VE', 'Venezuela'),
('VN', 'Vietnam'),
('YE', 'Yemen'),
('ZM', 'Zambia'),
('ZW', 'Zimbabwe')
;
