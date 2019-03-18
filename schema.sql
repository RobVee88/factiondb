CREATE DATABASE faction_db;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(400) NOT NULL,
    password_digest VARCHAR(600) NOT NULL,
    email VARCHAR(400) NOT NULL,
    is_admin BOOLEAN
);

CREATE TABLE cards (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    edition VARCHAR(100) NOT NULL,
    image_url TEXT NOT NULL
);

CREATE TABLE trades (
    id SERIAL PRIMARY KEY,
    user_id_owner INTEGER NOT NULL,
    user_id_borrower INTEGER NOT NULL,
    card_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    status VARCHAR(100)
);

CREATE TABLE downloaded_Cards (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	edition VARCHAR(100) NOT NULL,
	image_url TEXT NOT NULL
);



