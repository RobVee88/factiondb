CREATE DATABASE faction_db;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(400),
    password_digest VARCHAR(600),
    email VARCHAR(400)
);

CREATE TABLE cards (
    id SERIAL PRIMARY KEY,
    multiverse_id INTEGER,
    user_id INTEGER,
    amount INTEGER,
    name VARCHAR(100),
    edition VARCHAR(100),
    image_url TEXT
);

CREATE TABLE trades (
    id SERIAL PRIMARY KEY,
    user_id_owner INTEGER,
    user_id_borrower INTEGER,
    card_id INTEGER,
    amount INTEGER,
    status VARCHAR(100)
);


