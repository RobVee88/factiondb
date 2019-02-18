CREATE DATABASE faction_db;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(400),
    password_digest VARCHAR(600),
    email VARCHAR(400),
    is_admin BOOLEAN
);

CREATE TABLE cards (
    id SERIAL PRIMARY KEY,
    multiverse_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    amount INTEGER,
    name VARCHAR(100),
    edition VARCHAR(100),
    image_url TEXT
);

CREATE TABLE trades (
    id SERIAL PRIMARY KEY,
    user_id_owner INTEGER NOT NULL,
    user_id_borrower INTEGER NOT NULL,
    card_id INTEGER NOT NULL,
    amount INTEGER,
    status VARCHAR(100)
);


